Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab3BXA6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 19:58:41 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:40357 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759447Ab3BXA6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 19:58:39 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH] i2c: s3c2410: check for NULL pinctrl handle
Date: Sun, 24 Feb 2013 01:58:35 +0100
Message-ID: <31669750.ZZOiY1AEPv@flatron>
User-Agent: KMail/4.10 (Linux/3.8.0-gentoo; KDE/4.10.0; x86_64; ; )
In-Reply-To: <CACRpkdaFv=V8M_Ztb5-hrYm6YnXiG6fg6Z13y3NVFdszBk=7ZQ@mail.gmail.com>
References: <201302231855.47560.heiko@sntech.de> <5027662.bpQdq7jhyn@flatron> <CACRpkdaFv=V8M_Ztb5-hrYm6YnXiG6fg6Z13y3NVFdszBk=7ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 of February 2013 01:47:49 Linus Walleij wrote:
> On Sun, Feb 24, 2013 at 1:38 AM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> > The driver must know whether pin control is available, because it has
> > to fall back to legacy GPIO-based pin configuration if it is not.
> > This means that we must either check for NULL (which probably is not
> > right, since returned handle is considered to be opaque) or pin
> > control core must return an error code specific to this situation,
> > e.g. -ENODEV.
> OK so pass a flag like a bool in your platform data from the
> machine like go into <linux/platform_data/i2c-s3c2410.h>
> and add:
> 
> struct s3c2410_platform_i2c {
>         bool  use_that_old_gpio_interface;
>         (...)
> };
> 
> Instead of trying to semi-guess if the pinctrl framework is there?
> 
> Surely you know this when setting up the pdata from your machine?

Cases 2) and 3) are both DT-enabled cases, where there is no pdata coming 
from board-specific code.

In case of this particular driver, a check for presence of "gpios" 
property will be enough, because this driver does not use GPIO pins 
normally - they are just used for pin configuration, when legacy method 
has to be used.

However it will not work in case of drivers that also need some GPIO pins 
unrelated to the pins that have to be configured to dedicated functions.

Note that we are talking here about a temporary solution. The legacy DT-
based pin configuration will go away after all the DT-enabled platforms 
using this driver get migrated to pin control and so will the need to 
check if pin control is available.

Best regards,
Tomasz

