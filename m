Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3KYXbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:31:34 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:58146 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3KYXbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:31:32 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-watchdog@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: s3c2410_wdt: Only register for cpufreq on CPU_FREQ_S3C24XX
Date: Tue, 26 Nov 2013 00:31:30 +0100
Message-ID: <3917232.5usgOlQl6Q@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAD=FV=WijF-ZyST8p13Rog1VGSx+c-2MES+FpxbSGzd16rAZoA@mail.gmail.com>
References: <1385420137-32725-1-git-send-email-dianders@chromium.org> <5293DBEF.3010401@roeck-us.net> <CAD=FV=WijF-ZyST8p13Rog1VGSx+c-2MES+FpxbSGzd16rAZoA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 of November 2013 15:28:29 Doug Anderson wrote:
> Guenter,
> 
> On Mon, Nov 25, 2013 at 3:23 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On 11/25/2013 02:55 PM, Doug Anderson wrote:
> >>
> >> On modern SoCs the watchdog timer is parented on a clock that doesn't
> >> change every time we have a cpufreq change.  That means we don't need
> >> to constantly adjust the watchdog timer, so avoid registering for and
> >> dealing with cpufreq transitions unless we've actually got
> >> CPU_FREQ_S3C24XX defined.
> >>
> >> Note that this is more than just an optimization.  The s3c2410
> >> watchdog driver actually pats the watchdog on every CPU frequency
> >> change.  On modern systems these happen many times per second (even in
> >> a system where "nothing" is happening).  That effectively makes any
> >> userspace watchdog program useless (the watchdog is constantly patted
> >> by the kernel).  If we need CPU_FREQ_S3C24XX defined on a
> >> multiplatform kernel we'll need to make sure that kernel supports
> >> common clock and change this to user common clock framework.
> >>
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >> ---
> >>   drivers/watchdog/s3c2410_wdt.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/watchdog/s3c2410_wdt.c
> >> b/drivers/watchdog/s3c2410_wdt.c
> >> index 7d8fd04..4980f84 100644
> >> --- a/drivers/watchdog/s3c2410_wdt.c
> >> +++ b/drivers/watchdog/s3c2410_wdt.c
> >> @@ -264,7 +264,7 @@ static irqreturn_t s3c2410wdt_irq(int irqno, void
> >> *param)
> >>         return IRQ_HANDLED;
> >>   }
> >>
> >> -#ifdef CONFIG_CPU_FREQ
> >> +#ifdef CONFIG_CPU_FREQ_S3C24XX
> >>
> > Where is the CPU_FREQ_S3C24XX configuration option defined ? I don't see it
> > in the current upstream kernel, so it appears that this depends on some
> > out-of-tree changes.
> 
> Whoops!  I guess I just trusted another patch and didn't dig.  I was
> basing this on https://patchwork.kernel.org/patch/3023421/
> 
> Ah, I see that Tomasz just found the answer.  I'll update my patch.

Seems like I originally gave you the wrong symbol name, looking at our
internal 3.10 tree, where the rename is not present yet, and nobody
noticed. Sorry for that.

Best regards,
Tomasz

