Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab3JLFm6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 01:42:58 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25513 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3JLFm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 01:42:56 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-67-5258e15e1de0
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: sjg@chromium.org, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, wsa@the-dreams.de,
        khali@linux-fr.org, ben-linux@fluff.org, grant.likely@secretlab.ca,
        naveenkrishna.ch@gmail.com, broonie@kernel.org, dianders@chromium.org,
        cpgs@samsung.com
Subject: Re: [PATCH] i2c: s3c2410: dont need CPU_FREQ transitions for exynos
 series
Date: Sat, 12 Oct 2013 07:42:52 +0200
Message-id: <5982877.kDV2Xg8Ocr@amdn883>
User-Agent: KMail/4.10.5 (Linux/3.8.0-31-generic; KDE/4.10.5; x86_64; ; )
In-reply-to: <2030813.WOPcW68yit@amdn883>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
 <3245175.os31ym2KFi@amdn883> <2030813.WOPcW68yit@amdn883>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xa7pxDyOCDG7/EbaYtO4Ak8XUh0/Y
	LO4+P8xo8fKQpsXZZQfZLF6d2chm0fg30qLj7xdGi8u75rBZzDi/j8li0bb/zBbftmxjtFh5
	YhazA6/H7IaLLB5/V71g9tg56y67x6ZVnWweVxpOsnn0bVnF6PHzpY7HyVNPWDw+b5IL4Izi
	sklJzcksSy3St0vgynjeeY61YLNAxbeFfg2MH3m6GDk5JARMJNZMe8QEYYtJXLi3nq2LkYtD
	SGApo8Tmnw2MIAkhgXYmiW2Ha0BsNgE1ic8Nj9hAbBGg5uOvzrCDNDALLAOqWXiJGSQhLBAq
	8e3NUjCbRUBV4uiPaSwgNq+AhkRLwxmgoRwcogKeEt1HDUHCnAKaEnN2tTFBLG5klDj9aQlU
	vaDEj8n3wGxmAXmJffunskLYWhLrdx5nmsAoMAtJ2SwkZbOQlC1gZF7FKJpamlxQnJSea6RX
	nJhbXJqXrpecn7uJERJDX3cwLj1mdYhRgINRiYd3YmVEkBBrYllxZe4hRgkOZiUR3gP6QCHe
	lMTKqtSi/Pii0pzU4kOMTBycUg2MsxmOPeU5/Jv5bbU8O9usutl+nq3hVac/R3xceolP8c6F
	D0sf/U14YiTtnnnJZ8qhs6vfxoln6FZUrWzOEXY3lc+xqn7RX3xkVwBX7LFCloDJ3042+Irc
	N7DZodQrrHJB7rCzob3Z/JkVJjZ5msfL2/q9mj7uqz4tvC3Yd4dKUZf7HlG5BeuUWIozEg21
	mIuKEwF9O94LfwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 of October 2013 04:28:51 Tomasz Figa wrote:
> [Fixing incorrent mail addresses and dropping the old DT ML.]
> 
> On Saturday 12 of October 2013 04:22:04 Tomasz Figa wrote:
> > Hi Naveen,
> > 
> > On Friday 11 of October 2013 16:56:54 Naveen Krishna Chatradhi wrote:
> > > The exynos5 i2c clock is based on a fixed 66 MHz peripheral clock, and
> > > therefore is completely independent of the cpu frequency.
> > > Thus, registering for a CPU freq notifier is very wasteful.
> > > 
> > > This patch modifes the code such that, i2c bus registers to
> > > cpu_freq_transition only for non Exynos SoCs.
> > > 
> > > This change should save a bunch of cpufreq transitions calls
> > > which does not apply to exynos SoCs.
> > 
> > The idea is fine, although...
> > 
> > > Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> > > ---
> > >  drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> > > index cab1c91..d062fa7 100644
> > > --- a/drivers/i2c/busses/i2c-s3c2410.c
> > > +++ b/drivers/i2c/busses/i2c-s3c2410.c
> > > @@ -123,7 +123,7 @@ struct s3c24xx_i2c {
> > >  	struct s3c2410_platform_i2c	*pdata;
> > >  	int			gpios[2];
> > >  	struct pinctrl          *pctrl;
> > > -#ifdef CONFIG_CPU_FREQ
> > > +#if defined(CONFIG_CPU_FREQ) && !defined(CONFIG_ARCH_EXYNOS)
> > 
> > ...this is not a good coding practice, especially when already having
> > multiplatform kernels in sight.
> > 
> > The best way would be to check on which SoC we are running at runtime,
> > but since this might need changing a lot of code, then at least I would
> > change this from !defined(EXYNOS) to defined(S3C24XX), so it is not being
> > compiled in when S3C24XX support is not enabled and if it's enabled then
> > the notifier will be registered as a safe fallback that will run correctly
> > on all platforms.

Actually you can simply check for CONFIG_CPU_FREQ_S3C24XX here.

Best regards,
Tomasz

