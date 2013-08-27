Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3H0M0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:26:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23921 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3H0M0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:26:46 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-c8-521c9b04052d
From: Tomasz Figa <t.figa@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        linus.walleij@linaro.org, thomas.abraham@linaro.org,
        kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 1/4] pinctrl: Add s5pv210 support to pinctrl-exynos
Date: Tue, 27 Aug 2013 14:26:41 +0200
Message-id: <1882987.W6oKxzvqXu@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.9-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <521C71A1.4070609@samsung.com>
References: <1377595171-31116-1-git-send-email-m.krawczuk@partner.samsung.com>
 <521C71A1.4070609@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xa7oss2WCDN6uNbDoXXCVzWLKn+VM
	FpseX2O1uLxrDpvFjPP7mCxOrznFbHH4TTurxbEZSxgdODzuXNvD5rF5Sb3HwXd7mDz6tqxi
	9Pi8SS6ANYrLJiU1J7MstUjfLoEr4/qOnYwFn7krbi3sZG1gPMHZxcjJISFgItE9fSMzhC0m
	ceHeerYuRi4OIYGljBKLf7dBOV1MEr8+bGUDqWITUJP43PAIzBYR0JdYsuoiWBGzwDtGiVkz
	3rB2MXJwCAu4S5z6WAtisgioSqzcEghi8gpoSjzZGgHSyS+gLvFu21MmkLCogItE399MEJNT
	QFvi6Kx4kAohgXyJBS0b2EFsXgFBiR+T77GA2MwC8hL79k9lhbC1JNbvPM40gVFwFpKyWUjK
	ZiEpW8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJPy/7mBceszqEKMAB6MSD+/DFukg
	IdbEsuLK3EOMEhzMSiK8U5tlgoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwWkxZHuG2pzfFYJ7N
	am9vG+7zMe/rp+ucT3w57deO//0iYU4ZGjIM8QVPvnP/LOT77PWzyPnwid11t0ssWlwWuRw6
	W5qV/9a3Sa3rts7iqTe2yAl/mNnMdvCAceL1Cd5m/iG8PBOdmg/mxF8R0Xv28Xe35U3OC+vm
	zOXx37plUUHC5GjOJXVPlFiKMxINtZiLihMBbfmym10CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Tuesday 27 of August 2013 11:30:09 Sylwester Nawrocki wrote:
> Hi,
> 
> Just a few nits...
> 
> On 08/27/2013 11:19 AM, Mateusz Krawczuk wrote:
> > This patch implements pinctrl for s5pv210 and adds required device tree
> > bindings.
> Would be good to wrap this to not exceed 80 columns.
> 
> > Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> > ---
> 
> [...]
> 
> > diff --git a/drivers/pinctrl/pinctrl-exynos.c
> > b/drivers/pinctrl/pinctrl-exynos.c index a74b3cb..fc3e1d7 100644
> > --- a/drivers/pinctrl/pinctrl-exynos.c
> > +++ b/drivers/pinctrl/pinctrl-exynos.c
> > @@ -660,6 +660,64 @@ static void exynos_pinctrl_resume(struct
> > samsung_pinctrl_drv_data *drvdata)> 
> >  			exynos_pinctrl_resume_bank(drvdata, bank);
> >  
> >  }
> > 
> > +/* pin banks of s5pv210 pin-controller */
> > +static struct samsung_pin_bank s5pv210_pin_banks0[] = {
> 
> Couldn't it be 'static const' ?

This driver relies on this array not being const, as it calculates 
remaining contents of the samsung_pin_bank struct dynamically.

Even though it is far from being elegant, it works correctly, because there 
is always one separate array per each pin controller instance. This could 
be improved by separating the constant part from the variable part or by 
using this array as a template, i.e. marking as __initdata and copying its 
contents, but I couldn't get myself to do that. Feel free to submit 
appropriate patches ;).

Best regards,
Tomasz

