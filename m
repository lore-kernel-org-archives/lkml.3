Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbaIIO73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:59:29 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22726 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbaIIO7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:59:24 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-74-540f15c916a1
Message-id: <540F15B2.3000902@samsung.com>
Date: Tue, 09 Sep 2014 16:58:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
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
References: <20140909124306.2d5a0d76@canb.auug.org.au>
 <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <b7343e6296b5d1d68b7229b8307442fd4141bcb3.1410273306.git.m.chehab@samsung.com>
In-reply-to: <b7343e6296b5d1d68b7229b8307442fd4141bcb3.1410273306.git.m.chehab@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xa7onRflDDDr/KFr0Xn3OaPHj9QU2
	i94FV9kszja9YbfY9Pgaq8XlXXPYLHo2bGW1OLiwjdFixvl9TBYX18lb7Di1iNli696r7A48
	Ho03brB5bF6h5bF5Sb1H35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZZyYeZGpoImz4n/vB9YG
	xivsXYwcHBICJhInFoh3MXICmWISF+6tZ+ti5OIQEljKKNH6fxo7hPOJUWLukensIFW8AloS
	3yfsZgaxWQRUJfbu7ACLswkYSvQe7WMEsUUFwiSe/TrIBFEvKPFj8j0WEFtEwEDi8aKTYEOZ
	BY4xS3x6txJskLCAj0TnoXusENtuMEp0XmwBS3AKxEocXDGHCeRUZgE9ifsXtUDCzALyEpvX
	vGWewCgwC8mOWQhVs5BULWBkXsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREhFfdzAuPWZ1
	iFGAg1GJh3diGV+IEGtiWXFl7iFGCQ5mJRFe6xdAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyL
	YqJCk0TOnNl1d0aGeQf/Hi4fz4VdD321frcLshc/Xq+UsMTW6Zr7zaq+TZMNDbo2O/q47Dpd
	Z/flz+WHfY/sG/NqdJ9JV/+y0NrJYXmW239d6NqMHAuZS8bxfftqdj7acX+C6S6m57waUU9l
	jW5pn51dqCqfbhZjsN5wkkHGS/6FD7IN+JRYijMSDbWYi4oTATftR3xmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 16:38, Mauro Carvalho Chehab wrote:
> ERROR: "__bad_ndelay" [drivers/media/platform/s5p-jpeg/s5p-jpeg.ko] undefined!
> 
> Yet, it sounds a bad idea to use ndelay to wait for 100 us
> for the device to reset.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> index e51c078360f5..01eeacf28843 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-hw-exynos4.c
> @@ -23,7 +23,9 @@ void exynos4_jpeg_sw_reset(void __iomem *base)
>  	reg = readl(base + EXYNOS4_JPEG_CNTL_REG);
>  	writel(reg & ~EXYNOS4_SOFT_RESET_HI, base + EXYNOS4_JPEG_CNTL_REG);
>  
> +#ifndef CONFIG_COMPILE_TEST
>  	ndelay(100000);
> +#endif

Wouldn't be a better fix to replace ndelay(100000); with udelay(100),
rather than sticking in a not so pretty #ifndef ?

I guess usleep_range() couldn't simply be used, since
exynos4_jpeg_sw_reset() is called with a spinlock held.

--
Regards,
Sylwester
