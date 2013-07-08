Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3GHOyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:54:25 -0400
Received: from smtp-out-123.synserver.de ([212.40.185.123]:1067 "EHLO
	smtp-out-123.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3GHOyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:54:24 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16180
Message-ID: <51DAD2C3.8070203@metafoo.de>
Date: Mon, 08 Jul 2013 16:54:59 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Dan Williams <djbw@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Porter <matt@ohporter.com>
Subject: Re: [RFC] dmaengine: add dma_slave_get_caps api
References: <1373273650-31097-1-git-send-email-vinod.koul@intel.com> <51DAAA1F.5050002@metafoo.de> <20130708134024.GH16653@intel.com> <51DACC8D.5020201@metafoo.de> <20130708140357.GI16653@intel.com>
In-Reply-To: <20130708140357.GI16653@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 04:03 PM, Vinod Koul wrote:
> On Mon, Jul 08, 2013 at 04:28:29PM +0200, Lars-Peter Clausen wrote:
>> On 07/08/2013 03:40 PM, Vinod Koul wrote:
>>> On Mon, Jul 08, 2013 at 02:01:35PM +0200, Lars-Peter Clausen wrote:
>>>> On 07/08/2013 10:54 AM, Vinod Koul wrote:
>>>>> +/* struct dma_slave_caps - expose capabilities of a slave channel only
>>>>> + *
>>>>> + * @src_addr_widths: bit mask of src addr widths the channel supports
>>>>> + * @dstn_addr_widths: bit mask of dstn addr widths the channel supports
>>>>> + * @src_burst_lengths: bit mask of src slave burst lengths supported
>>>>> + * @dstn_burst_lengths: bit mask of dstn slave burst lengths supported
>>>>
>>>> I'm not sure if we need the burst_lengths fields. For one we can only
>>>> express a max burst length up 32. And usually it is fine if the dma
>>>> controller does not support the burst length requested by the slave driver,
>>>> since this only specifies the maximum and the dma controller driver can
>>>> choose a value below this limit. E.g. if the max burst length is set to 16
>>>> it is still fine if the controller only supports a burst length of 8.
>>> well how are you picking up which one to use?
>>> The idea is that you query and match that with system and client to get best
>>> throughput. If you have IP block which over generations change capablities you
>>> can runtime query and then program the channel smartly!
>>
>> The client would always request the largest burst size it can support, and
>> the dma master would then select a burst size equal or smaller to it
>> depending on what it can support.
> not really, most dmac drivers will return an error when they find a value is not
> in the supported list. And that is precisely what we would like to prevent.
> If you look at current model, it mostly program value which we know is already
> a capablity and works model.

The majority of the DMA drivers will either accept any maxburst value (which
is probably broken) or round down. The only ones which accept only a fixed
set of burst sizes seem to be mmp_pdma, mmp_tdma and sa11x0-dma.

- Lars
