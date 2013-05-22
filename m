Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab3EVOIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:08:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59206 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3EVOIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:08:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] regulator: ab8500-ext: Don't register without initialisation data
Date: Wed, 22 May 2013 16:08:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
References: <1369226853-16978-1-git-send-email-lee.jones@linaro.org> <1369226853-16978-3-git-send-email-lee.jones@linaro.org> <CACRpkdYHiwbGonH80aJfHxP6F+hLb+_KdCr_g5ae1Yr-v=WcxA@mail.gmail.com>
In-Reply-To: <CACRpkdYHiwbGonH80aJfHxP6F+hLb+_KdCr_g5ae1Yr-v=WcxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305221608.10759.arnd@arndb.de>
X-Provags-ID: V02:K0:bWAJok2Hj96tPUvE1lKQENeBPRzdFVEEMS8ItoqTeqY
 VNMjP1o+KYA7SZfnf9i4hMm2qcAxUcvOWCrxs32g7p6C/01uT1
 5HBnRgNo8R/5gZawhptaWhVoW30C+GGnmshL7iGblPl2pwqWxZ
 X9Rcm0RTH3bgqaYEX6MeOAkv9ttpu6bmNTZQHnDEwvfZ2c/L4x
 Y7O6LLHkcsYkGkOManJLHb1XcGozXYlF7FDnlYIa/pPsK2k3Op
 RXpUSyWznwARC0qe/11Evj0tRRzIH4rcCyS/VlXCQuz7+y/5ou
 w9yu1N06MTddjbZtD1o8VyZFUo4HZAuhgG7BawpA+YGNpn2Q5Q
 so543eslebkleQ64710w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 May 2013, Linus Walleij wrote:
> > diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
> > index b4d4547..8421537 100644
> > --- a/drivers/regulator/ab8500-ext.c
> > +++ b/drivers/regulator/ab8500-ext.c
> > @@ -334,6 +334,12 @@ int ab8500_ext_regulator_init(struct platform_device *pdev)
> >                 return -EINVAL;
> >         }
> >
> > +       /* have any external regulators been specified? */
> > +       if (pdata->num_ext_regulator == 0) {
> > +               dev_warn(&pdev->dev, "Not using external regulators\n");
> > +               return 0;
> > +       }
> 
> dev_warn() is really when we warn about something really nasty, worse
> than dev_err(). It seems dev_info() is more apropriate.

Are you confusing it with dev_crit()?

This is how the levels are defined, and "warning" is less urgent than "error":

#define KERN_EMERG      KERN_SOH "0"    /* system is unusable */
#define KERN_ALERT      KERN_SOH "1"    /* action must be taken immediately */
#define KERN_CRIT       KERN_SOH "2"    /* critical conditions */
#define KERN_ERR        KERN_SOH "3"    /* error conditions */
#define KERN_WARNING    KERN_SOH "4"    /* warning conditions */
#define KERN_NOTICE     KERN_SOH "5"    /* normal but significant condition */
#define KERN_INFO       KERN_SOH "6"    /* informational */
#define KERN_DEBUG      KERN_SOH "7"    /* debug-level messages */

	Arnd
