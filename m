Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbbAHPbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:31:00 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:60903 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbbAHPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:30:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJwdr7WvzLqPmui3N4H-wVgSURN6wYD=dm1HyU2HUmXOg@mail.gmail.com>
References: <1418266726-12004-1-git-send-email-a.kesavan@samsung.com>
	<1418266726-12004-2-git-send-email-a.kesavan@samsung.com>
	<1418292513.3188.4.camel@pengutronix.de>
	<20141211103919.GA6067@arm.com>
	<1418298046.3188.10.camel@pengutronix.de>
	<20141211145849.GH31456@e104818-lin.cambridge.arm.com>
	<CAM4voakdfiTecW8YH0znnyB-dTnX_fsrRcH2McABwdk3T9drkQ@mail.gmail.com>
	<20150105181823.GG4081@atomide.com>
	<CAM4voa=xoM4AuGxwk0TpLnGz9jbZ02awFOrY_KgWCSzROJR6cA@mail.gmail.com>
	<1420563279.3719.15.camel@pengutronix.de>
	<CAL_JsqJwdr7WvzLqPmui3N4H-wVgSURN6wYD=dm1HyU2HUmXOg@mail.gmail.com>
Date: Thu, 8 Jan 2015 21:00:57 +0530
Message-ID: <CAM4voakHnwRzVsYYO2Dd2f9_PxZGqvqT8xveA-Y6N4ReOfhdmw@mail.gmail.com>
Subject: Re: [PATCH 2/2] misc: sram: switch to ioremap_wc from ioremap
From: Abhilash Kesavan <kesavan.abhilash@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
        linux-rockchip@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "padma.v@samsung.com" <padma.v@samsung.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "bcousson@baylibre.com" <bcousson@baylibre.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "kgene@kernel.org" <kgene@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob and Philipp,

On Tue, Jan 6, 2015 at 10:57 PM, Rob Herring <robherring2@gmail.com> wrote:
> On Tue, Jan 6, 2015 at 10:54 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
>> Hi Abhilash,
>>
>> Am Dienstag, den 06.01.2015, 19:57 +0530 schrieb Abhilash Kesavan:
>>> >> From the existing dts files, omap, imx, rockchip and exynos seem to be
>>> >> the only users of the sram allocator code. I have tested this on
>>> >> Exynos5420, Exynos5800 and Exynos7; there is no change in behavior
>>> >> seen on these boards. Tested-by for other SoCs would be appreciated.
>>> >
>>> > Sorry for the delay, these seems to boot OK on omap4, so from that
>>> > point of view:
>>> >
>>> > Tested-by: Tony Lindgren <tony@atomide.com>
>>>
>>> Thanks a lot for testing this. If someone with imx and rockchip boards
>>> could help test this out, then we could look to get this in.
>>
>> This shouldn't be a problem on i.MX, the coda driver doesn't access SRAM
>> from the CPU at all.
>
> Audio buffers are typically (perhaps not in mainline) in SRAM on i.MX
> chips which are accessed by CPU and probably mmap'ed to userspace.
> That could cause a mismatch in mappings although I would not expect
> both the kernel and user space to touch the buffer. That being said, I
> don't think this change should cause problems for i.MX (from what I
> can remember).

Thanks for the confirmation regarding the i.MX chips. That leaves
rockchip, can someone help with it please ?

Regards,
Abhilash
>
> Rob
