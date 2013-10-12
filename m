Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3JLGg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 02:36:56 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35895 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3JLGgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 02:36:55 -0400
MIME-Version: 1.0
In-Reply-To: <5982877.kDV2Xg8Ocr@amdn883>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
 <3245175.os31ym2KFi@amdn883> <2030813.WOPcW68yit@amdn883> <5982877.kDV2Xg8Ocr@amdn883>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Sat, 12 Oct 2013 12:06:34 +0530
Message-ID: <CAHfPSqCHUAccv4Usd1XcZ8MzD+Jf=jHSWWQ0m1Mj64nKCN7_jw@mail.gmail.com>
Subject: Re: [PATCH] i2c: s3c2410: dont need CPU_FREQ transitions for exynos series
To: Tomasz Figa <t.figa@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, sjg@chromium.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        wsa@the-dreams.de, khali@linux-fr.org, Ben Dooks <ben-linux@fluff.org>,
        grant.likely@secretlab.ca, broonie@kernel.org, dianders@chromium.org,
        cpgs@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 October 2013 11:12, Tomasz Figa <t.figa@samsung.com> wrote:
> On Saturday 12 of October 2013 04:28:51 Tomasz Figa wrote:
>> [Fixing incorrent mail addresses and dropping the old DT ML.]
>>
>> On Saturday 12 of October 2013 04:22:04 Tomasz Figa wrote:
>> > Hi Naveen,
>> >
>> > On Friday 11 of October 2013 16:56:54 Naveen Krishna Chatradhi wrote:
>> > > The exynos5 i2c clock is based on a fixed 66 MHz peripheral clock, and
>> > > therefore is completely independent of the cpu frequency.
>> > > Thus, registering for a CPU freq notifier is very wasteful.
>> > >
>> > > This patch modifes the code such that, i2c bus registers to
>> > > cpu_freq_transition only for non Exynos SoCs.
>> > >
>> > > This change should save a bunch of cpufreq transitions calls
>> > > which does not apply to exynos SoCs.
>> >
>> > The idea is fine, although...
>> >
>> > > Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> > > ---
>> > >  drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
>> > >  1 file changed, 2 insertions(+), 2 deletions(-)
>> > >
>> > > diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
>> > > index cab1c91..d062fa7 100644
>> > > --- a/drivers/i2c/busses/i2c-s3c2410.c
>> > > +++ b/drivers/i2c/busses/i2c-s3c2410.c
>> > > @@ -123,7 +123,7 @@ struct s3c24xx_i2c {
>> > >   struct s3c2410_platform_i2c     *pdata;
>> > >   int                     gpios[2];
>> > >   struct pinctrl          *pctrl;
>> > > -#ifdef CONFIG_CPU_FREQ
>> > > +#if defined(CONFIG_CPU_FREQ) && !defined(CONFIG_ARCH_EXYNOS)
>> >
>> > ...this is not a good coding practice, especially when already having
>> > multiplatform kernels in sight.
>> >
>> > The best way would be to check on which SoC we are running at runtime,
>> > but since this might need changing a lot of code, then at least I would
>> > change this from !defined(EXYNOS) to defined(S3C24XX), so it is not being
>> > compiled in when S3C24XX support is not enabled and if it's enabled then
>> > the notifier will be registered as a safe fallback that will run correctly
>> > on all platforms.
>
> Actually you can simply check for CONFIG_CPU_FREQ_S3C24XX here.
sure, this makes it more meaningful. will make the modifications and resubmit.
>
> Best regards,
> Tomasz
>



-- 
Shine bright,
(: Nav :)
