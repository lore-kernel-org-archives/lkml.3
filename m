Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935935Ab3DKOeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:34:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765117Ab3DKOeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:34:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: ab8500: pass AB8500 IRQ to debugfs code by resource
Date: Thu, 11 Apr 2013 16:33:53 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
References: <1365669779-14953-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1365669779-14953-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304111633.54110.arnd@arndb.de>
X-Provags-ID: V02:K0:/8ufYJBJyKGvrGkfHAA7e+oS5t//oJL10YtMPGr+eIO
 +PPlkZXLOgsrwTpIz45x2zkNLpNIBDmGKP1i/hK1smktuISydG
 MwrD3SSiGZ48HqfSzrYBUkBAQja9WEUH/jQ9WxLnb6tbWe7wX+
 VP0RuaRe1RuzbV1CwvkPRGNuCdrzj9DwiVn2ky4TZJnh1aDqcN
 AvFY+uml3iLaQAN4Kdz4FIxSuBVH2dl1Bk3vMloSGCtsaz+5a4
 ojD2xGA31LV+EO3LyVbkAIz3Xhs4j5cprdeM6bQKPDy5n7cy5Q
 ERKmRtJ9UeWC7VNFpw11tsY9IDICmBdpGXlMPcv/xTo9nuA2JL
 oOf4ulRASwvz9Kf9l/Ds=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 April 2013, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The AB8500 debug code which was merged in parallell with the
> multiplatform work incidentally introduced a new instance using
> the <mach/irqs.h> header which is now deleted, causing this
> build regression:
> 
> drivers/mfd/ab8500-debugfs.c:95:23:
> fatal error: mach/irqs.h: No such file or directory
> compilation terminated.
> make[4]: *** [drivers/mfd/ab8500-debugfs.o] Error 1
> 
> The code most certainly never worked with device tree either
> since that does not rely on this kind of hard-coded interrupt
> numbers.
> 
> Fix the problem at the root by passing it as a named resource
> from the ab8500-core driver.

I think this won't work because the interrupts in ab8500_debug_resources
are now local numbers relative to the ab8500->domain irq_domain,
while IRQ_DB8500_AB8500 is an global interrupt number.

	Arnd
