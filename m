Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3LUE32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 23:29:28 -0500
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:52891 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753107Ab3LUE31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 23:29:27 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2734:2828:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:7652:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:1274
X-HE-Tag: brake27_17da69aeda14d
X-Filterd-Recvd-Size: 3498
Message-ID: <1387600147.2353.67.camel@joe-AO722>
Subject: MAINTAINERS: Describe differences between F: and N: patterns
From: Joe Perches <joe@perches.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel@pengutronix.de
Date: Fri, 20 Dec 2013 20:29:07 -0800
In-Reply-To: <1387570919-13627-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1387569330.616105313@f421.i.mail.ru>
	 <1387570919-13627-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a difference in how scripts/get_maintainer.pl treats
F: and N: file pattern matches.

Describe those differences in the MAINTAINERS file.

Signed-off-by: Joe Perches <joe@perches.com>
---

On Fri, 2013-12-20 at 21:21 +0100, Uwe Kleine-König wrote:
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Acked-by: Mark Brown <broonie@linaro.org>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> On Fri, Dec 20, 2013 at 11:55:30PM +0400, Alexander Shiyan wrote:
> > [...]
> > > +F: arch/arm/boot/dts/efm32*
> > > +F: arch/arm/configs/efm32_defconfig
> > > +F: arch/arm/include/debug/efm32.S
> > > +F: arch/arm/mach-efm32/
> > > +F: drivers/clk/clk-efm32gg.c
> > > +F: drivers/clocksource/time-efm32.c
> > > +F: drivers/spi/spi-efm32.c
> > > +F: drivers/tty/serial/efm32-uart.c
> > > +F: include/dt-bindings/clock/efm32-cmu.h
> > > +F: include/linux/platform_data/efm32-*
> > 
> > Maybe "N" keyword with "efm32" is better here?
> ah, didn't know about that. Nice.
> 
> So the changes since v1 are:
>  - use N: efm32
>  - add acks from Greg and Mark
>    I assume it's ok to keep them for v2 assuming they mean them being OK with
>    me maintaining the efm32 stuff and not the way to express that in
>    MAINTAINERS.

 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1344816..ebdb523 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -93,6 +93,11 @@ Descriptions of section entries:
 	N: Files and directories with regex patterns.
 	   N:	[^a-z]tegra	all files whose path contains the word tegra
 	   One pattern per line.  Multiple N: lines acceptable.
+	   scripts/get_maintainer.pl has different behavior for files that
+	   match F: pattern and matches of N: patterns.  By default,
+	   get_maintainer will not look at git log history when an F: pattern
+	   match occurs.  When an N: match occurs, git log history is used
+	   to also notify the people that have git commit signatures.
 	X: Files and directories that are NOT maintained, same rules as F:
 	   Files exclusions are tested before file matches.
 	   Can be useful for excluding a specific subdirectory, for instance:


