Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab3J1UAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 16:00:07 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:56801 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3J1UAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 16:00:04 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: "'Kishon Vijay Abraham I'" <kishon@ti.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm@vger.kernel.org,
        kyungmin.park@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com
Subject: Re: [PATCH v2 1/5] phy: Add new Exynos USB PHY driver
Date: Mon, 28 Oct 2013 21:00:01 +0100
Message-ID: <1548448.GBuE52miBt@flatron>
User-Agent: KMail/4.11.2 (Linux/3.11.6-gentoo; KDE/4.11.2; x86_64; ; )
In-Reply-To: <025b01ced3e4$ec685db0$c5391910$%debski@samsung.com>
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com> <526A90B9.3040501@ti.com> <025b01ced3e4$ec685db0$c5391910$%debski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamil,

On Monday 28 of October 2013 14:52:19 Kamil Debski wrote:
> Hi Kishon,
> 
> Thank you for your review! I will answer your comments below.
[snip]
> > > +
> > > +	switch (drv->cfg->cpu) {
> > > +	case TYPE_EXYNOS4210:
> > 
> > > +	case TYPE_EXYNOS4212:
> > Lets not add such cpu checks inside driver.
> 
> Some SoC have a special register, which switches the OTG lines between
> device and host modes. I understand that it might not be the prettiest
> code. I see this as a good compromise between having a single huge
> driver for all Exynos SoCs and having a multiple drivers for each SoC
> version. PHY IPs in these chips very are similar but have to be handled
> differently. Any other ideas to solve this issue?

Maybe adding a flag in drv->cfg called, for example, .has_mode_switch 
could solve this problem without having to check the SoC type explicitly?

[snip]
> > > +#ifdef CONFIG_PHY_EXYNOS4210_USB
> > 
> > Do we really need this?
> 
> No we don't. The driver can always support all Exynos SoC versions.
> These config options were added for flexibility.
> 
> > > +extern const struct uphy_config exynos4210_uphy_config; #endif
> > > +
> > > +#ifdef CONFIG_PHY_EXYNOS4212_USB
> > 
> > Same here.
> > 
> > > +extern const struct uphy_config exynos4212_uphy_config; #endif
> > > +
> > > +static const struct of_device_id exynos_uphy_of_match[] = { #ifdef
> > > +CONFIG_PHY_EXYNOS4210_USB
> > 
> > #if not needed here.
> 
> If the #ifdef CONFIG_PHY_EXYNOS4210_USB is removed then yes. Otherwise
> it is necessary - exynos4210_uphy_config may be undefined.

I believe this and other ifdefs below are needed, otherwise, with support
for one of the SoCs disabled, the driver could still bind to its 
compatible value.

Best regards,
Tomasz

