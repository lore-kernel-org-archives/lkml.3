Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaFXSJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:09:15 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:56356 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaFXSJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:09:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jim Davis <jim.epost@gmail.com>, sfr@canb.auug.org.au,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, sbkim73@samsung.com,
        sameo@linux.intel.com, grant.likely@linaro.org, robh+dt@kernel.org,
        devicetree <devicetree@vger.kernel.org>
Subject: mfd: sec-core requires regulators
Date: Tue, 24 Jun 2014 20:09:07 +0200
Message-ID: <6906564.1ehoeq1QjB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140624154833.GR13803@lee--X1>
References: <CA+r1ZhhFYip3Jp2c3d8tNpD-vK8Pkf7DzrKTtk6Gy8uOOO3Ucw@mail.gmail.com> <29237234.T7oGEGKuvp@wuerfel> <20140624154833.GR13803@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mVH1L0JDBPPwC4LKpb85Kcrwocz9Sx8IrRgwKIm3a3f
 5jn66CKb8HRgRu+o4SZyo6WVdH2XBnUtJGx6IbtwlqtbV0350g
 1n/BTVlqVbTxgcxa7fF4vJFUrWHcxx8YpAnzncbuW8mc77/HM5
 b3902VIi7+fucbznFAHiJJV6HVOC76AFKs081QPDsJBNxxqmQt
 MUs/yDpWg/NVsKidqB7gxhyeZjtDsF6Q5KwApy04gQ/EPcatjA
 GJ8KAYKsou1PJ0vq+4IKI3CCgDr36pgS1TlrpaSYJyGmtrmt48
 Z5xVrvJgeflIjOb8BW1OH1UYs//xig/XOmatd5n5Og/Gv4PfLr
 l9rjiUkytaTuQAvA96kA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added sec-core mfd module calls the regulator_suspend_prepare()
function, which is only available if the regulator API is provided. This
matches the usage of the driver, so we can just add a Kconfig dependency.

Reported-by: Jim Davis <jim.epost@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 207c433..1caa3c5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -582,7 +582,7 @@ config MFD_RC5T583
 
 config MFD_SEC_CORE
        bool "SAMSUNG Electronics PMIC Series Support"
-       depends on I2C=y
+       depends on I2C=y && REGULATOR
        select MFD_CORE
        select REGMAP_I2C
        select REGMAP_IRQ
