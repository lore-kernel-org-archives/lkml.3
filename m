Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3J2KQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:16:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41189 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab3J2KQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:16:10 -0400
Date: Tue, 29 Oct 2013 11:16:07 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: RE: [PATCH v2 1/5] phy: Add new Exynos USB PHY driver
In-reply-to: <1548448.GBuE52miBt@flatron>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>
Cc: "'Kishon Vijay Abraham I'" <kishon@ti.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm@vger.kernel.org,
        kyungmin.park@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, gautam.vivek@samsung.com,
        mat.krawczuk@gmail.com
Message-id: <030c01ced48f$e2d513f0$a87f3bd0$%debski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7bit
Thread-index: Ac7UGE5ncd/G8kz3TyGaBdWyIGapVgAd2i2Q
X-AuditID: cbfec7f5-b7ef66d00000795a-66-526f8ae92c54
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xy7ovu/KDDDbO57OYf+Qcq0XblYPs
	Fhee9rBZnG16w24xbed/VovLu+awWcw4v4/JYtGyVmaLtUfusluc7b/NZnH4TTurxfoZr1ks
	Vu36w+jA67Fz1l12j74tqxg9jt/YzuTxeZNcAEsUl01Kak5mWWqRvl0CV8bv2xPYC9YIVPx9
	1sXWwHiGp4uRk0NCwETi6pfjrBC2mMSFe+vZuhi5OIQEljJKzLgwgQnCaWCS+LTiJ0sXIwcH
	m4CmxKp7HiANIkDmsSfP2EFqmAWmMEs8+TWBGaJhC6PE1V2f2ECqOIGqpix7ywhiCwvYSfz4
	9A7MZhFQlVh75Q/Yal4BB4kX6zoYIWxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMcoSEgLrE
	o7+6IKaIgJFE2xQ/iAoRibsNz1knMArNQjJoFpJBs5AMmoWkZQEjyypG0dTS5ILipPRcI73i
	xNzi0rx0veT83E2MkPj6uoNx6TGrQ4wCHIxKPLwWbPlBQqyJZcWVuYcYJTiYlUR4mxuBQrwp
	iZVVqUX58UWlOanFhxiZODilGhiTv0+SULm+7Pz3e3mv2yZ02gREPN9p3bn8v+CF+QcmsST8
	Ef9r1Kumeydm1gzr2x+4uc22H92995ki+6fcrycPXoufIG2w2u9Qz8HTk8pfviv/9+fBdc97
	3wTvHzK5M3v5t4fbtQyv/zYpfr3tmeHyP+Vitg/ktj14Z2PVGDp7pfyRfyzb3mn/sFRiKc5I
	NNRiLipOBAD54IfVjQIAAA==
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com>
 <526A90B9.3040501@ti.com> <025b01ced3e4$ec685db0$c5391910$%debski@samsung.com>
 <1548448.GBuE52miBt@flatron>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Tomasz Figa [mailto:tomasz.figa@gmail.com]
> Sent: Monday, October 28, 2013 9:00 PM
> 
> Hi Kamil,
> 
> On Monday 28 of October 2013 14:52:19 Kamil Debski wrote:
> > Hi Kishon,
> >
> > Thank you for your review! I will answer your comments below.
> [snip]
> > > > +
> > > > +	switch (drv->cfg->cpu) {
> > > > +	case TYPE_EXYNOS4210:
> > >
> > > > +	case TYPE_EXYNOS4212:
> > > Lets not add such cpu checks inside driver.
> >
> > Some SoC have a special register, which switches the OTG lines
> between
> > device and host modes. I understand that it might not be the
> prettiest
> > code. I see this as a good compromise between having a single huge
> > driver for all Exynos SoCs and having a multiple drivers for each SoC
> > version. PHY IPs in these chips very are similar but have to be
> > handled differently. Any other ideas to solve this issue?
> 
> Maybe adding a flag in drv->cfg called, for example, .has_mode_switch
> could solve this problem without having to check the SoC type
> explicitly?

Sounds like a good idea.
 
> [snip]
> > > > +#ifdef CONFIG_PHY_EXYNOS4210_USB
> > >
> > > Do we really need this?
> >
> > No we don't. The driver can always support all Exynos SoC versions.
> > These config options were added for flexibility.
> >
> > > > +extern const struct uphy_config exynos4210_uphy_config; #endif
> > > > +
> > > > +#ifdef CONFIG_PHY_EXYNOS4212_USB
> > >
> > > Same here.
> > >
> > > > +extern const struct uphy_config exynos4212_uphy_config; #endif
> > > > +
> > > > +static const struct of_device_id exynos_uphy_of_match[] = {
> > > > +#ifdef CONFIG_PHY_EXYNOS4210_USB
> > >
> > > #if not needed here.
> >
> > If the #ifdef CONFIG_PHY_EXYNOS4210_USB is removed then yes.
> Otherwise
> > it is necessary - exynos4210_uphy_config may be undefined.
> 
> I believe this and other ifdefs below are needed, otherwise, with
> support for one of the SoCs disabled, the driver could still bind to
> its compatible value.
> 

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland


