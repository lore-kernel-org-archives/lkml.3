Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab3C1OsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 10:48:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49929 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab3C1OsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 10:48:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] clocksource: Fix build in non-OF case
Date: Thu, 28 Mar 2013 14:47:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Axel Lin <axel.lin@ingics.com>
References: <1364473805-773-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201303281308.22738.arnd@arndb.de> <20130328131044.GA18316@opensource.wolfsonmicro.com>
In-Reply-To: <20130328131044.GA18316@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303281447.51532.arnd@arndb.de>
X-Provags-ID: V02:K0:s0KFdQf6Osc5Y85NXG0hOY/FsK80WG7fa4WdrsAe449
 wVlLoE3/Eqc6Wgse39KXB0JdFlCKLyb24oqFkM6kU9mzkDTcLI
 EugvXFatNXDN8k02lVI84AQcOyrE/P4+9AgGKrgABQH1Rdbony
 N1RkGCmglbxprDjt8gvmvjqbPOzeZbmS+LjUC79IsdyiyXgTZA
 92apq8RxiMucDcqOowid8Bvv/TuOGBmS3QYJavNzRoShzT7Yso
 AQb3DInumcqqsB+xc6Dc+GLQKo4xJbFmkPjL32kJBATOEPpH4l
 /t1BjsjLhmU2nrPp1wxt4Q01viGCiIJlp0lzQL/66Jzh4voQQU
 t1+eAyy7VJJw8GspPZ4Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 March 2013, Mark Brown wrote:
> On Thu, Mar 28, 2013 at 01:08:22PM +0000, Arnd Bergmann wrote:
> > On Thursday 28 March 2013, Mark Brown wrote:
> 
> > > That still looks like it'll reference the function?
> 
> > Yes, that is intentional. The idea is to create a reference to the
> > function so gcc doesn't complain about unused symbols if the function
> > gets marked static, but at the same time mark the data structure we
> > define as unused so gcc can drop the structure as well as the function
> > if they are not referenced from anywhere else.  This should let us
> > get away with fewer #ifdef hacks in the code, better build-time coverage
> > but without producing larger object code.
> 
> So GCC is supposed to be smart enough to figure this out and users need
> to not do the ifdefs?  I have to say this does seem a bit surprising
> from a user point of view but it does make sense from a general niceness
> point of view.

Yes, I'm pretty sure that all gcc-4.x versions can do this right at -Os
and -O2 levels. The new gcc-4.8 -Og level may get it wrong but is also
broken for many other things we do in the kernel, just like building with
gcc -O0.

Since we recently introduced the IS_ENABLED() macro to test for preprocessor
symbols, I think there is a general trend away from any #ifdefs in driver
code.

	Arnd
