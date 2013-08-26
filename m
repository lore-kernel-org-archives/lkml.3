Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3HZThl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:37:41 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60762 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab3HZThj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:37:39 -0400
Message-ID: <521BADC1.7000003@ti.com>
Date: Tue, 27 Aug 2013 01:04:25 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v2] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1377287613-16491-1-git-send-email-joelf@ti.com> <521B3212.3050405@ti.com> <521B87C0.1090507@ti.com>
In-Reply-To: <521B87C0.1090507@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 8/26/2013 10:22 PM, Joel Fernandes wrote:
> On 08/26/2013 05:46 AM, Sekhar Nori wrote:
>> On Saturday 24 August 2013 01:23 AM, Joel Fernandes wrote:
>>> HWMOD removal for MMC and Crypto is breaking edma_start as the events are
>>> being manually triggered due to unused channel list not being clear. Atleast
>>> breakage has been seen on these peripherals, but it is expected Audio (McASP)
>>> maybe breaking too.
>>>
>>> This patch fixes the issue, by reading the "dmas" property from the DT node if
>>> it exists and clearing the bits in the unused channel list so that these channels
>>> are not manually triggered.
>>>
>>> v2 changes:
>>> Reduced indendation by returning from if block.
>>
>> Is this a v2 or v3 since you already sent a v2 about a month back?
> 
> No, there aren't any changes since v2, I just resubmitted the same patch.

Heh, it does seem to contain some indentation changes per your
documentation :)

> 
>>>
>>> Reviewed-by: Sekhar Nori <nsekhar@ti.com>
>>> Reported-by: Balaji T K <balajitk@ti.com>
>>> Cc: Pantel Antoniou <panto@antoniou-consulting.com>
>>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>>> ---
>>> Note:
>>> Patch should go in for -rc cycle as it fixes existing crypto drivers.
>>
>> We agreed the patch is not needed in -rc cycle since there are no
>> current EDMA users in DT-boot?
> 
> There is now, crypto and EDMA DT patches are being merged in.

They are being merged in v3.12, right? So you meant the -rc cycle of
v3.12? If yes, no need to wait for a broken v3.12-rc1 to come out. It is
possible to queue fixes during merge window too.

Thanks,
Sekhar
