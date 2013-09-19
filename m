Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3ISJf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:35:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49735 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3ISJf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:35:26 -0400
Message-ID: <523AC548.5020908@ti.com>
Date: Thu, 19 Sep 2013 15:05:04 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: <joelf@ti.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>, Jyri Sarah <jsarha@ti.com>,
        Koen Kooi <koen@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v3] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1378839171-14455-1-git-send-email-joelf@ti.com> <5231903F.7080301@ti.com> <5233B471.40603@ti.com> <5236F00B.5040605@ti.com> <5237314D.7080102@ti.com> <5237E3C3.8050602@ti.com> <5237EAF3.70505@ti.com> <5237F147.1020302@ti.com> <52386733.8010807@ti.com>
In-Reply-To: <52386733.8010807@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 September 2013 07:59 PM, Joel Fernandes wrote:
> On 09/17/2013 01:05 AM, Sekhar Nori wrote:
> [..]
>>>> mixed messages. In short, we aim for consistency with situation today,
>>>> not tomorrow.
>>>
>>> What you're asking to do infact breaks consistency with the rest of the code.
>>
>> Well, ideally we support second CC even with DT to be consistent all
>> around. Since that has not happened, I don't want the code to pretend
>> that it it supports the second channel controller with DT that too only
>> in parts of code.
> 
> Ok, I agree that the bindings don't talk about encoding a controller number in
> the channel provided from DT so it shouldn't assume that without binding
> updates. Following this suggestion, I've update the patch to the below:
> 
> ---8<---
> From: Joel Fernandes <joelf@ti.com>
> Subject: [PATCH v6] ARM: EDMA: Fix clearing of unused list for DT DMA resources
> 
> HWMOD removal for MMC is breaking edma_start as the events are being manually
> triggered due to unused channel list not being clear.
> 
> The above issue is fixed by reading the "dmas" property from the DT node if it
> exists and clearing the bits in the unused channel list if the dma controller
> used by any device is EDMA. For this purpose we use the of_* helpers to parse
> the arguments in the dmas phandle list.
> 
> Also introduced is a minor clean up of a checkpatch error in old code.

The patch looks good to me. I made some modifications to commit message
- mostly for brevity.

    ARM: edma: dt: create unused channel list

    HWMOD removal for MMC is breaking edma_start() as the events
    are being manually triggered due to EDMA unused channel list
    not being ready.

    The above issue is fixed by reading the "dmas" property from
    the DT node if it exists and then clearing the bits in the
    unused channel list if the dma controller used by any device
    is EDMA.

    This is similar to approach taken in non-DT case.

    Also introduced is a minor clean up of a checkpatch error in
    old code.

Thanks,
Sekhar

