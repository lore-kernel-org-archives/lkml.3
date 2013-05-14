Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab3ENOVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 10:21:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30973 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592Ab3ENOVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 10:21:53 -0400
X-AuditID: cbfee61a-b7efb6d000003eed-d8-5192487f9226
From: Tomasz Figa <t.figa@samsung.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 2/4] dma: add dmaengine driver for Samsung s3c24xx SoCs
Date: Tue, 14 May 2013 16:21:36 +0200
Message-id: <3254712.MAHxRAdAN5@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.2 (Linux/3.8.8-gentoo; KDE/4.10.2; x86_64; ; )
In-reply-to: <CACRpkda-wQyo8aYxbW9RJNcR3Kwe2w5AhaAuUHfaxBksa_Pm2A@mail.gmail.com>
References: <201305111330.05046.heiko@sntech.de>
 <201305111331.25405.heiko@sntech.de>
 <CACRpkda-wQyo8aYxbW9RJNcR3Kwe2w5AhaAuUHfaxBksa_Pm2A@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e+xoG69x6RAgxcPzC029z9gs/j/6DWr
	Re+Cq2wWU/4sZ7LY9Pgaq8XlXXPYLGac38dkcfsyr8XLvv0sDpweLc09bB4Tm9+xeyze85LJ
	4861PWwem5fUe/RtWcXosf3aPGaPz5vkAjiiuGxSUnMyy1KL9O0SuDLOvrvLVLBWtGL1ukNM
	DYx/BLoYOTkkBEwkprc1sUPYYhIX7q1n62Lk4hASmM4o0XHpDjOE08Ik8fLCC1aQKjYBNYnP
	DY/YQGwRAR2J7m0/WUGKmAXmMkusbvrKDJIQFvCUeD5jBVgDi4CqxPRrzWBxXgFNibtt58Ca
	+QXUJd5te8oEYosKuEp82P8MLM4pECyx+tN3RhBbSGAeo8T7RX4QvYISPybfYwGxmQW0JZ68
	u8AKYetI9H7/xjyBUXAWkrJZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4
	Xp5J7WBc2WBxiFGAg1GJh7ehbmKgEGtiWXFl7iFGCQ5mJRFeM7tJgUK8KYmVValF+fFFpTmp
	xYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoY428ut+jNd/w4NWBjYeiBpXePPune
	Ef50krmogXlpzMZftvKPLz5KXKyok1P4Z/vB5sVbV668/FAhXsNpQ6p6Yv+Xhm9nYtP+7bhw
	08N04+mJPfdiDyyrzZzVOncH8+Kfq9Jmf997OrPV+v1LX9Mb+/7NTzG33tG3s77591fNgPLA
	Rw+2q1/++laJpTgj0VCLuag4EQA+o/T0kwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Heiko,

On Tuesday 14 of May 2013 14:47:19 Linus Walleij wrote:
> On Sat, May 11, 2013 at 1:31 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > Conceptually the s3c24xx-dma feels like a distant relative of the pl08x
> > with numerous virtual channels being mapped to a lot less physical ones.
> > The driver therefore borrows a lot from the amba-pl08x driver in this
> > regard. Functionality-wise the driver gains a memcpy ability in addition
> > to the slave_sg one.
> > 
> > The driver currently only supports the "newer" SoCs which can use any
> > physical channel for any dma slave. Support for the older SoCs where
> > each channel only supports a subset of possible dma slaves will have to
> > be added later.
> > 
> > Tested on a s3c2416-based board, memcpy using the dmatest module and
> > slave_sg partially using the spi-s3c64xx driver.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> So have I understood correctly if I assume that *some* S3C
> variants, i.e. this: arch/arm/mach-s3c64xx/dma.c
> have a vanilla, unmodified, or just slightly modified
> PL08x block, while this DMAC is something probably based on
> the PL08x where some ASIC engineer has had a good time hacking
> around in the VHDL code to meet some feature requirements.
> Correct? Or plausible guess?
> 
> Exactly *how* far away from the pl08x hardware is it?

AFAIK the DMAC of S3C24xx is completely different from PL08x. I think Heiko 
just meant that it uses similar concepts, like virtual channels.

> I guess you have already come to the conclusion that the
> amba-pl08x.c driver cannot be augmented to handle this hardware
> after some educated reading of that code?
> 
> But are really no parts reusable?
> 
> For example, if the LLIs have the same layout, could we split
> out the LLI handling from amba-pl08x into a separate file and reuse
> that?
> 
> The more you share with amba-pl08x the better for everyone,
> I am positively sure. And please include Russell on the review
> chain, he wrote the virtual channel abstraction.
> 
> If I was given the option amongst S3C work I would definatley
> have augmented the amba-pl08x.c to handle the stuff in
> arch/arm/mach-s3c64xx/dma.c *first* then started to work on
> this driver, but I guess you might not be working on s3c64xx?

Well, I still hope that someone will pick up the work on adapting PL08x driver 
to support PL080s of S3C64xx as well, but most likely it will end up with me 
doing it, as a part of DT support for S3C64xx.

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center
SW Solution Development, Kernel and System Framework

