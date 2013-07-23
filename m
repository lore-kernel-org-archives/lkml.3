Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3GWJcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:32:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35688 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab3GWJct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:32:49 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-4a-51ee4dbf7a41
From: Tomasz Figa <t.figa@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        linus.walleij@stericsson.com, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 07/22] ARM: exynos: Remove '0x's from Exynos4110 DTSI file
Date: Tue, 23 Jul 2013 11:32:43 +0200
Message-id: <1610492.3P9vcH2Wcz@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-reply-to: <20130723085552.GF26801@laptop>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <2350088.9z671SCjFz@flatron> <20130723085552.GF26801@laptop>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/xK7r7fd8FGvS8ZbL4O+kYu0Xvgqts
	Fve/HmW0WNPylsVi0+NrrBaXd81hs5hxfh+TxapdfxgdODx+/5rE6LFz1l12jzvX9rB5bF5S
	79G3ZRWjx/ela9g9Pm+SC2CP4rJJSc3JLEst0rdL4Mo4NVW74DpPxYkPrcwNjM84uxg5OSQE
	TCT6ts9mgbDFJC7cW8/WxcjFISSwlFFi7/lfUE4Xk8TkryfZQarYBNQkPjc8AkpwcIgIqEic
	e2MOUsMs8JhRYsvKGWCThAX8JP4dWQpmswioSvy7fYgNxOYV0JTYcfQKK4jNL6Au8W7bUyaQ
	OaICbhITPuaDhDkFdCSaWnoYIfY2M0p0HfvKDNErKPFj8j2wmcwC8hL79k9lhbC1JNbvPM40
	gVFwFpKyWUjKZiEpW8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJDK+7mBceszqEKMA
	B6MSD+8C37eBQqyJZcWVuYcYJTiYlUR4l0q9CxTiTUmsrEotyo8vKs1JLT7EyMTBKdXAGCDd
	994lJP+tV+1ZowLT3mMsD20qz8QaxHU5y4uoWfQcFLjg9pix4uOeqB3LtR9qMSeXt5YtZTH5
	yhY8lf/o59nb96X0fbi2YjvLPOtUGy1+hS0frhdfX/vWJ2q6UOOzpeHH5I8WqxyW3Na862Bk
	x+Lst+ZLCh7pzxU5+1VFyYGn/9jfoyb2SizFGYmGWsxFxYkAsttqa2oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 of July 2013 09:55:52 Lee Jones wrote:
> On Mon, 22 Jul 2013, Tomasz Figa wrote:
> > Hi Lee,
> > 
> > On Monday 22 of July 2013 11:52:26 Lee Jones wrote:
> > > Cc: Kukjin Kim <kgene.kim@samsung.com>
> > > Cc: linux-samsung-soc@vger.kernel.org
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > > 
> > >  arch/arm/boot/dts/exynos4210.dtsi | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm/boot/dts/exynos4210.dtsi
> > > b/arch/arm/boot/dts/exynos4210.dtsi index b7f358a..53e2527 100644
> > > --- a/arch/arm/boot/dts/exynos4210.dtsi
> > > +++ b/arch/arm/boot/dts/exynos4210.dtsi
> > > @@ -72,7 +72,7 @@
> > > 
> > >  		};
> > >  	
> > >  	};
> > > 
> > > -	clock: clock-controller@0x10030000 {
> > > +	clock: clock-controller@10030000 {
> > > 
> > >  		compatible = "samsung,exynos4210-clock";
> > >  		reg = <0x10030000 0x20000>;
> > >  		#clock-cells = <1>;
> > 
> > This looks fine, but please fix commit message - it should be
> > Exynos4210. Also some explanation why this change is needed would be
> > good, even if it's obvious.
> 
> Hi Tomasz,
> 
> I'm happy to fixup the $SUBJECT line, but do we really have to enter
> an explanation if it's obvious? Seems a little belt and braces.

It's obvious for us, people working with device tree, but for people that 
usually don't it might not be.

Something among following lines would be fine:

This patch removes "0x" prefix from addresses in DT nodes for the sake of 
consistency with other nodes and assumed convention.

Best regards,
Tomasz

