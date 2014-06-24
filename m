Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaFXO6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:58:35 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:54897 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaFXO6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:58:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jim Davis <jim.epost@gmail.com>
Cc: sfr@canb.auug.org.au, linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, sbkim73@samsung.com,
        sameo@linux.intel.com, lee.jones@linaro.org, grant.likely@linaro.org,
        robh+dt@kernel.org, devicetree <devicetree@vger.kernel.org>
Subject: Re: randconfig build error with next-20140624, in drivers/mfd/sec-core.c
Date: Tue, 24 Jun 2014 16:57:59 +0200
Message-ID: <29237234.T7oGEGKuvp@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CA+r1ZhhFYip3Jp2c3d8tNpD-vK8Pkf7DzrKTtk6Gy8uOOO3Ucw@mail.gmail.com>
References: <CA+r1ZhhFYip3Jp2c3d8tNpD-vK8Pkf7DzrKTtk6Gy8uOOO3Ucw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Qvj/wZEauaL99P9ZIsl2dmtsISq+h/CI+dY5X1hoGQb
 xKM7eOlQeXb6ByLi4JlnaMqhGME7d3+LhztMnvJN8sk7cL8EH8
 Hy4L+RIwClHmCGJbSvaw1ojKFwULJXmTBNSs9dkOLMUrx/lLZF
 ktqOK/1mtgRqraKdBqFnW5co6cDzept8ftsNHxMfZe8XzQdAd1
 i3tqZ9vwsBc8AB4zXGyvtSLkyFMxq/TVxCQIYnwhyeKORT/Npn
 PtGgBg6/Nk8WvZaRjzroqr2ilGpa83je/3W575ulDQUXcPo5FJ
 4mfz6QnuM7yJYM5EP2Y4iJ+3TkMnqnrLykvTS4HlzktCMOB/w9
 3dMqnLPU4OKAwfm2o+xo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 June 2014 07:39:04 Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/built-in.o: In function `sec_pmic_suspend':
> sec-core.c:(.text+0x31e02c): undefined reference to `regulator_suspend_prepare'
> make: *** [vmlinux] Error 1

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 207c433..1caa3c5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -582,7 +582,7 @@ config MFD_RC5T583
 
 config MFD_SEC_CORE
 	bool "SAMSUNG Electronics PMIC Series Support"
-	depends on I2C=y
+	depends on I2C=y && REGULATOR
 	select MFD_CORE
 	select REGMAP_I2C
 	select REGMAP_IRQ

