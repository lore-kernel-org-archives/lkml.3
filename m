Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3FAH7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 03:59:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45010 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751566Ab3FAH7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 03:59:33 -0400
From: "Strashko, Grygorii" <grygorii.strashko@ti.com>
To: Kevin Hilman <khilman@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mfd: twl-core: convert to module_init()
Thread-Topic: [PATCH] mfd: twl-core: convert to module_init()
Thread-Index: AQHOXkFkixu2tfWPk0Ca0ybI95RtWJkgfZhV
Date: Sat, 1 Jun 2013 07:59:03 +0000
Message-ID: <902E09E6452B0E43903E4F2D568737AB31F402@DNCE04.ent.ti.com>
References: <1370033794-5357-1-git-send-email-khilman@linaro.org>
In-Reply-To: <1370033794-5357-1-git-send-email-khilman@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.49]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

It's done alreday here:
https://patchwork.kernel.org/patch/2477541/ - mfd: twl-core: convert to module_i2c_driver()
 (Samuel has taken this one)
- and -
https://patchwork.kernel.org/patch/2477561/ - i2c: omap: convert to module_platform_driver()
 (you can vote here - TWL can't be shifted without I2C)

(Sent from Web Outlook - sorry if format is wrong)
Best regards,
- Grygorii Strashko 

________________________________________
From: linux-omap-owner@vger.kernel.org [linux-omap-owner@vger.kernel.org] on behalf of Kevin Hilman [khilman@linaro.org]
Sent: Friday, May 31, 2013 11:56 PM
To: Samuel Ortiz; Tony Lindgren
Cc: linux-omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org; open list
Subject: [PATCH] mfd: twl-core: convert to module_init()

There's no reason for twl-core to be subsys_inicall anymore.  Anything
using twl that early needs a rethink, or deferred probe changes.

Boot tested and RTC wake tested (via TWL RTC) on OMAP platforms:
3530/Beagle, 3730/Beagle-xM, 3530/Overo, 3730/Overo-STORM, 4430/Panda,
4460/Panda-ES.

Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 drivers/mfd/twl-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index 89ab4d9..7749b9e 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -1309,7 +1309,7 @@ static int __init twl_init(void)
 {
        return i2c_add_driver(&twl_driver);
 }
-subsys_initcall(twl_init);
+module_init(twl_init);

 static void __exit twl_exit(void)
 {
--
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-omap" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
