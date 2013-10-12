Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3JLC25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 22:28:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35932 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3JLC2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 22:28:55 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-fa-5258b3e41dd1
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>, sjg@chromium.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, wsa@the-dreams.de,
        khali@linux-fr.org, ben-linux@fluff.org, grant.likely@secretlab.ca,
        naveenkrishna.ch@gmail.com, broonie@kernel.org, dianders@chromium.org,
        cpgs@samsung.com
Subject: Re: [PATCH] i2c: s3c2410: dont need CPU_FREQ transitions for exynos
 series
Date: Sat, 12 Oct 2013 04:28:51 +0200
Message-id: <2030813.WOPcW68yit@amdn883>
User-Agent: KMail/4.10.5 (Linux/3.8.0-31-generic; KDE/4.10.5; x86_64; ; )
In-reply-to: <3245175.os31ym2KFi@amdn883>
References: <1381490814-20890-1-git-send-email-ch.naveen@samsung.com>
 <3245175.os31ym2KFi@amdn883>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xy7pPNkcEGdyZa2kxad0BJoupD5+w
	Wdx9fpjR4uUhTYuzyw6yWbw6s5HNovFvpEXH3y+MFpd3zWGzmHF+H5PFom3/mS2+bdnGaLHy
	xCxmB16P2Q0XWTz+rnrB7LFz1l12j02rOtk8rjScZPPo27KK0ePnSx2Pk6eesHh83iQXwBnF
	ZZOSmpNZllqkb5fAlXG3sYGlYLdAxebZ95gbGKfydjFyckgImEjsn3+OCcIWk7hwbz1bFyMX
	h5DAUkaJow1tjBBOO5PEnO8f2ECq2ATUJD43PAKzRQTcJC7dmQXWwSwwhUmif+s2VpCEsECo
	xLc3S5lBbBYBVYkd356zg9i8AhoS1ye9BVrHwSEq4CnRfdQQxOQU0JT49oEbxBQSSJHof8IM
	USwo8WPyPRYQm1lAXmLf/qmsELaWxPqdx5kmMArMQlI2C0nZLCRlCxiZVzGKppYmFxQnpeca
	6hUn5haX5qXrJefnbmKERNCXHYyLj1kdYhTgYFTi4Z1QGREkxJpYVlyZe4hRgoNZSYT3gD5Q
	iDclsbIqtSg/vqg0J7X4ECMTB6dUA6MtJ8usSv2gysdp1oZmXVvvh1a7uuqyHdl4REZ+z9TU
	0xc5+F3Y1A5P5D4Ya/W+teL258dFvZNXuSzjkly92vrCv8VdRYnuAicmnz1XE77ib9UBf62k
	qTlHWD11NPVu/5kUv3HDz9sP70govJG8mbd+o19bb7t9q/DT/cZOZcePtERIKp2d+0OJpTgj
	0VCLuag4EQDGdtcvfgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Fixing incorrent mail addresses and dropping the old DT ML.]

On Saturday 12 of October 2013 04:22:04 Tomasz Figa wrote:
> Hi Naveen,
> 
> On Friday 11 of October 2013 16:56:54 Naveen Krishna Chatradhi wrote:
> > The exynos5 i2c clock is based on a fixed 66 MHz peripheral clock, and
> > therefore is completely independent of the cpu frequency.
> > Thus, registering for a CPU freq notifier is very wasteful.
> > 
> > This patch modifes the code such that, i2c bus registers to
> > cpu_freq_transition only for non Exynos SoCs.
> > 
> > This change should save a bunch of cpufreq transitions calls
> > which does not apply to exynos SoCs.
> 
> The idea is fine, although...
> 
> > Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> > ---
> >  drivers/i2c/busses/i2c-s3c2410.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> > index cab1c91..d062fa7 100644
> > --- a/drivers/i2c/busses/i2c-s3c2410.c
> > +++ b/drivers/i2c/busses/i2c-s3c2410.c
> > @@ -123,7 +123,7 @@ struct s3c24xx_i2c {
> >  	struct s3c2410_platform_i2c	*pdata;
> >  	int			gpios[2];
> >  	struct pinctrl          *pctrl;
> > -#ifdef CONFIG_CPU_FREQ
> > +#if defined(CONFIG_CPU_FREQ) && !defined(CONFIG_ARCH_EXYNOS)
> 
> ...this is not a good coding practice, especially when already having
> multiplatform kernels in sight.
> 
> The best way would be to check on which SoC we are running at runtime,
> but since this might need changing a lot of code, then at least I would
> change this from !defined(EXYNOS) to defined(S3C24XX), so it is not being
> compiled in when S3C24XX support is not enabled and if it's enabled then
> the notifier will be registered as a safe fallback that will run correctly
> on all platforms.
> 
> Best regards,
> Tomasz
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
