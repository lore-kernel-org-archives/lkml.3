Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161882AbaDPQGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:06:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40085 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161858AbaDPQGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:06:04 -0400
Message-ID: <534EAA49.7030702@ti.com>
Date: Wed, 16 Apr 2014 11:05:29 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Vinod Koul <vinod.koul@intel.com>
CC: <davinci-linux-open-source@linux.davincidsp.com>,
        Lars-Peter Clausen <lars@metafoo.de>, <linux-kernel@vger.kernel.org>,
        <mporter@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, <dmaengine@vger.kernel.org>,
        <dan.j.williams@intel.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 05/14] arm: common: edma: Select event queue 1 as default
 when booted with DT
References: <1396357575-30585-1-git-send-email-peter.ujfalusi@ti.com> <1396357575-30585-6-git-send-email-peter.ujfalusi@ti.com> <5347A4FD.1030803@ti.com> <5347ACDE.7040407@ti.com> <5347AE49.5020109@ti.com> <5347B7F8.2000508@ti.com> <20140411094217.GA32284@intel.com> <5347D2CC.4030407@ti.com> <20140411113154.GB32284@intel.com> <5347DEDA.2060008@ti.com> <20140411124641.GC32284@intel.com> <534BCCD3.9060805@ti.com> <534BD0B5.5000004@ti.com> <534BD788.3050406@ti.com> <534BF181.6060503@ti.com> <534E7EB0.9000601@ti.com>
In-Reply-To: <534E7EB0.9000601@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 07:59 AM, Peter Ujfalusi wrote:
[..]
>>>>> If the dma-priority is missing we should assume lowest priority (0).
>>>>> The highest priority depends on the platform. For eDMA3 in AM335x it is three
>>>>> level. For designware controller you might have the range 0-8 as valid.
>>>>>
>>>>> The question is how to get this information into use?
>>>>> We can take the priority number in the core when the dma channel is requested
>>>>> and add field to "struct dma_chan" in order to store it and the DMA drivers
>>>>> could have access to it.
>>
>> How about Vinod's idea of extending dma_slave_config? Priority is
>> similar to rest of the runtime setup dmaengine_slave_config() is meant
>> to do.
> 
> The dma_slave_config is prepared by the client drivers, so they would need to
> be updated to handle the priority for the DMA. This would lead to duplicated
> code - unless we have a small function in dmaengine core to fetch this
> information, but still all dmaengine clients would need to call that.
> IMHO it would be better to let the dmaengine core to take the priority for the
> channel when it has been asked so client drivers does not need to know about it.
> 

I still feel it is much cleaner to keep this out of DT and have audio
driver configure the channel manually for higher priority. Because,
AFAIK audio is the only device that uses slave DMA and needs higher
priority. I'd imagine everyone else who needs high priority, have their
own dedicated DMAC, so from that sense I don't see the priority
mechanism being used a lot anywhere else but audio, so atleast we can
rule out things like code duplication in other drivers. Priority can be
set to a default of low for those drivers that don't configure the
channel for priority. I'm also OK with EDMA driver configuring channel
for higher priority manually for the Cyclic case like you did initially.

Thanks,
-Joel

