Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab3E3Snl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:43:41 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:65019 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544Ab3E3Snf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:43:35 -0400
Message-ID: <51A79E8F.4070209@metafoo.de>
Date: Thu, 30 May 2013 20:46:39 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Ralf Baechle <ralf@linux-mips.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Maarten ter Huurne <maarten@treewalker.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 3/6] dma: Add a jz4740 dmaengine driver
References: <1369931105-28065-1-git-send-email-lars@metafoo.de> <1369931105-28065-4-git-send-email-lars@metafoo.de> <20130530171225.GA3767@intel.com>
In-Reply-To: <20130530171225.GA3767@intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 07:12 PM, Vinod Koul wrote:
> On Thu, May 30, 2013 at 06:25:02PM +0200, Lars-Peter Clausen wrote:
>> This patch adds dmaengine support for the JZ4740 DMA controller. For now the
>> driver will be a wrapper around the custom JZ4740 DMA API. Once all users of the
>> custom JZ4740 DMA API have been converted to the dmaengine API the custom API
>> will be removed and direct hardware access will be added to the dmaengine
>> driver.
>>
>> +
>> +#include <asm/mach-jz4740/dma.h>
> Am bit worried about having header in arch. Why cant we have this drivers header
> in linux/. That way same IP block cna be reused across archs.
> I was hoping that you would have move it in 6th patch, but that isnt the case

At the end of this series the header only contains the slave ids used by the
various cores on the JZ4740. Since these ids differ from SoC to SoC it doesn't
make much sense to move the header to a generic location.

> 
> 
>> +static int jz4740_dma_alloc_chan_resources(struct dma_chan *c)
>> +{
>> +	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
>> +
>> +	chan->jz_chan = jz4740_dma_request(chan, NULL);
>> +	if (!chan->jz_chan)
>> +		return -EBUSY;
>> +
>> +	jz4740_dma_set_complete_cb(chan->jz_chan, jz4740_dma_complete_cb);
>> +
>> +	return 0;
> Sorry, I didnt reply on this one. The API expects you to allocate a pool of
> descriptors. These descriptors are to be used in .device_prep_xxx calls later.

The size of the descriptor is not fixed, so they can not be pre-allocated. And
this is nothing new either, most of the more recently added dmaengine drivers
allocate their descriptors on demand.

- Lars

