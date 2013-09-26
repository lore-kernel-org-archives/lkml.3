Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3IZXNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:13:37 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:61036 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3IZXNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:13:34 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1380232546-821-1-git-send-email-joelf@ti.com>
References: <1380232546-821-1-git-send-email-joelf@ti.com>
Date: Thu, 26 Sep 2013 16:13:33 -0700
Message-ID: <CAOesGMgELbnuu8PM7Ah2xKo2H5rzgAN3w0g6wA7aVFsjuds-8g@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: EDMA: Fix clearing of unused list for DT DMA resources
From: Olof Johansson <olof@lixom.net>
To: Joel Fernandes <joelf@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
        Pantel Antoniou <panto@antoniou-consulting.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        "arm@kernel.org" <arm@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 2:55 PM, Joel Fernandes <joelf@ti.com> wrote:
> HWMOD removal for MMC is breaking edma_start as the events are being manually
> triggered due to unused channel list not being clear.
>
> The above issue is fixed by reading the "dmas" property from the DT node if it
> exists and clearing the bits in the unused channel list if the dma controller
> used by any device is EDMA. For this purpose we use the of_* helpers to parse
> the arguments in the dmas phandle list.
>
> Also introduced is a minor clean up of a checkpatch error in old code.
>
> Reviewed-by: Sekhar Nori <nsekhar@ti.com>
> Reported-by: Balaji T K <balajitk@ti.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Nishanth Menon <nm@ti.com>
> Cc: Pantel Antoniou <panto@antoniou-consulting.com>
> Cc: Jason Kridner <jkridner@beagleboard.org>
> Cc: Koen Kooi <koen@dominion.thruhere.net>
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
> Just resending this patch after discussing with Sekhar and Olof.

Actually, the patch you talked to me about was v3 of this. It seems
that you have reposted v6 but labelled it v3. This is very confusing.

> AM335x is being booted by many users such as the beaglebone community. DT is
> the only boot method available for all these users.  EDMA is required for the
> operation for many common peripherals in AM335x SoC such as McASP, MMC and
> Crypto.
>
> Although EDMA DT nodes are going in only for 3.13, in reality the kernel has
> been used for more than a year with EDMA code and out of tree EDMA DTS patches.
> Hence though the DT nodes are still not in mainline, this patch can be still be
> considered a critical fix as such and it would be great if it could be included
> in 3.12-rc release. Thanks.

This is really the root of this problem. If you sit on code out of
tree for a year, and something breaks that we couldn't even have
detected since we didn't have the out-of-tree pieces. We'll help you
the first few times (such as now) but we will eventually stop caring.

If I was in a worse mood, then I'd just say that since your users
already has to have out-of-tree code to even use this functionality,
they could just add this fix on top of that stack of patches. But I'm
in a slightly better mood than that and I'll pick it up this time. :)

> More details about why this broke an existing feature folks were using:
> Previously the DMA resources for platform devices were being populated through
> HWMOD, however with the recent clean ups with HWMOD, this data has been moved
> to Device tree. The EDMA code though is not aware of this so it fails to fetch
> the DMA resources correctly which it needs to prepare the unused channel list
> (basically doesn't properly clear the channels that are in use, in the unused
> list).

So that we can learn for next time: What should we (as in us
maintainers and you TI) have done differently to avoid this?


-Olof
