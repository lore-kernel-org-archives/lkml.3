Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbaIIPJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:09:47 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:33480 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaIIPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:09:44 -0400
X-AuditID: cbfec373-b7f9d6d00000479f-7e-540f1837b7e6
Date: Tue, 09 Sep 2014 12:09:36 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2/3] [media] s5p-jpeg: Fix compilation with COMPILE_TEST
Message-id: <20140909120936.527bd852.m.chehab@samsung.com>
In-reply-to: <540F15B2.3000902@samsung.com>
References: <20140909124306.2d5a0d76@canb.auug.org.au>
 <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <b7343e6296b5d1d68b7229b8307442fd4141bcb3.1410273306.git.m.chehab@samsung.com>
 <540F15B2.3000902@samsung.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t/hIF1zCf4Qg98H2Sx6rz5ntPjx+gKQ
	teAqm8XZpjfsFpseX2O1uLxrDptFz4atrBYHF7YxWsw4v4/JYsepRcwWh9+0s1ps3XuV3YHH
	o/HGDTaPzSu0PDYvqffo27KK0ePzJrkA1igum5TUnMyy1CJ9uwSujNn7j7IV7OGqOLRmKnMD
	402OLkZODgkBE4lz704zQdhiEhfurWfrYuTiEBJYwihx8fdyKKeZSWLzphY2kCoWAVWJrj3P
	WUBsNgEjiVeNLawgtoiAvsSSVRfBGpgFjjFLfHq3khkkISzgI9F56B5YEa+AlcTO/o/sIDan
	gLbEjmlroTb8ZJRYdL+XHeIOZ4mfMycxQjQISvyYfA9sG7OAlsTmbU2sELa8xOY1b5knMArM
	QlI2C0nZLCRlCxiZVzGKlhYnFxQnpeca6RUn5haX5qXrJefnbmKEREbxDsYXG6wOMQpwMCrx
	8J6I4QsRYk0sK67MPcQowcGsJMJr/QIoxJuSWFmVWpQfX1Sak1p8iJGJg1OqgXEWwxPRXzfq
	RTYfuVv0ukX+/NT0bcYR8j0SN5/y1H59uMft05SdW7dtXDC7oWY9Qwl/V8DyTVt4VwQsKFF+
	ozd/kUzZdL4F34yWXK1ap50yv8osK6Z2xpzQlPl1Z6RWVWTU75/gJ+iTLzWdU70q7o9C50x7
	z4ApHFkmtxfK3PjyYsmzAEbf1ndKLMUZiYZazEXFiQB1nhOXagIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 09 Sep 2014 16:58:58 +0200
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> On 09/09/14 16:38, Mauro Carvalho Chehab wrote:
> > ERROR: "__bad_ndelay" [drivers/media/platform/s5p-jpeg/s5p-jpeg.ko] undefined!
> > 
> > Yet, it sounds a bad idea to use ndelay to wait for 100 us
> > for the device to reset.
> > 
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > 
> > diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> > index e51c078360f5..01eeacf28843 100644
> > --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> > +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> > @@ -23,7 +23,9 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
> >  	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
> >  	writel(reg & ~EXYNOS4_SOFT_RESET_HI, base + EXYNOS4_JPEG_CNTL_REG);
> >  
> > +#ifndef CONFIG_COMPILE_TEST
> >  	ndelay(100000);
> > +#endif
> 
> Wouldn't be a better fix to replace ndelay(100000); with udelay(100),
> rather than sticking in a not so pretty #ifndef ?

Works for me. I'll submit a new version.

> I guess usleep_range() couldn't simply be used, since
> exynos4_jpeg_sw_reset() is called with a spinlock held.

Ok.

Regards,
Mauro
