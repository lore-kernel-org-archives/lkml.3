Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab3DVWNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 18:13:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59461 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab3DVWNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 18:13:34 -0400
Message-ID: <5175B602.3020701@ti.com>
Date: Mon, 22 Apr 2013 17:13:22 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] dma: of: Remove check on always true condition
References: <1366619613-30639-1-git-send-email-lars@metafoo.de> <1366619613-30639-2-git-send-email-lars@metafoo.de> <5175A317.1010304@ti.com> <5175A4F5.1050304@metafoo.de>
In-Reply-To: <5175A4F5.1050304@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.115.140]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/22/2013 04:00 PM, Lars-Peter Clausen wrote:
> On 04/22/2013 10:52 PM, Jon Hunter wrote:
>>
>> On 04/22/2013 03:33 AM, Lars-Peter Clausen wrote:
>>> Both of_dma_nbcells field of the of_dma_controller and the args_count field of
>>> the dma_spec are initialized by parsing the #dma-cells attribute of their device
>>> tree node. So if the device tree nodes of a DMA controller and the dma_spec
>>> match this means that of_dma_nbcells and args_count will also match. So the
>>> second test in the of_dma_find_controller loop is redundant because given the
>>> first test yields true the second test will also yield true. So we can safely
>>> remove the test whether of_dma_nbcells matches args_count. Since this was the
>>> last user of the of_dma_nbcells field we can remove it altogether.
>>
>> This assumes that someone has correctly added the dma information to the
>> dma slave binding. I could see systems where different dma controllers
>> have different of_dma_nbcells and so someone could put the enter wrong
>> number of cells for a dma slave binding. Its really to catch user error.
> 
> No, this assumes nothing. The condition will _always_ be true.
> 
> dma_spec->args_count is initialized by parsing the #dma-cells attribute of
> dma_sepc->np. of_dma->of_dma_nbcells is initialized by parsing the #dma-cells
> attribute of of_dma->of_node. If ofdma->of_node equals dma_spec->np then
> dma_spec->args_count will also equal of_dma->of_dma_nbcells.

Thanks for the clarification. I should have looked more closely at
of_parse_phandle_with_args().

Yes I agree it will always be true if count is less than or equal to
MAX_PHANDLE_ARGS (which defaults to 8). It is very unlikely that someone
would use more than 8 and I guess it does warn on this condition.

if (out_args) {
	int i;
	if (WARN_ON(count > MAX_PHANDLE_ARGS))
		count = MAX_PHANDLE_ARGS;
	out_args->np = node;
	out_args->args_count = count;
	for (i = 0; i < count; i++)
		out_args->args[i] = be32_to_cpup(list++);
}

Cheers
Jon
