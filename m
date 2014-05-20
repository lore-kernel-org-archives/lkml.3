Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbaETK46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:56:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48368 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaETK44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:56:56 -0400
Message-ID: <537B34C9.1020508@ti.com>
Date: Tue, 20 May 2014 16:26:09 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH v3 00/13]  ARM/DT: edma: IP configuration from hardware
 and cleanups
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com> <537A01F2.2090107@ti.com> <537A36F9.40004@ti.com>
In-Reply-To: <537A36F9.40004@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2014 10:23 PM, Peter Ujfalusi wrote:
> On 05/19/2014 04:06 PM, Sekhar Nori wrote:
>> On Friday 16 May 2014 05:47 PM, Peter Ujfalusi wrote:
>>> Hi,
>>>
>>> Changes since v2:
>>> - Comments from Sekhar and Arnd has been addressed best as I could.
>>> - Use the CCCFG information in all cases instead of pdata provided information
>>> - To achieve this I needed to do a bit more cleanup in this series
>>> - In the documentation patch, retrain the old properties for reference
>>> - Cleanups in the old davinci board files and removing edma_soc_info members
>>>
>>> Changes sicne v1:
>>> - added missing patch to remove the memset from edma_of_parse_dt()
>>>
>>> We are requesting redundant information via DT for the driver since the very same
>>> data is available in the HW: by reading and decoding the content of CCCFG
>>> register we can get:
>>> Number of channels: NUM_DMACH
>>> Number of regions: NUM_REGN
>>> Number of slots (PaRAM sets): NUM_PAENTRY
>>> Number of TC/EQ: NUM_EVQUE
>>>
>>> So these does not need to be provided by the DT binding.
>>>
>>> The driver will no longer look for these properties from DT and they can be
>>> removed from the binding documentation and from the dtsi files as well.
>>> The change will not introduce regression when new kernel is booted using older
>>> DTB (since we just ignore the mentioned properties).
>>
>> Applied all patches and pushed to branch v3.16/edma of:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/nsekhar/linux-davinci.git
>>
>> Since the patches did not apply cleanly, please verify. I tested on
>> DA850 EVM using MMC/SD as EDMA user.
> 
> The patches in this series looks OK in your branch.
> However I can not find the following commits in there, which I have in linux-next:
> c689a7b79c28 Merge remote-tracking branch 'slave-dma/next'
> cdae05a0f0f7 dmaengine: edma: Make reading the position of active channels work
> cf7eb979116c ARM: common: edma: Fix xbar mapping
> 232b223d8281 dmaengine: edma: Set DMA_CYCLIC capability flag
> 7cf2af90cd51 arm: common: edma: Save the number of event queues/TCs
> 
> They might come via different route...

Vinod,

Do you have an immutable branch based on which I can send this patch
series to ARM-SoC? Some of the patches in the series depend on code that
went through your tree.

Or if you are comfortable taking this series through your tree, thats
okay by me too. We are still waiting for acks from DT maintainers on the
binding change patches.

Thanks,
Sekhar
