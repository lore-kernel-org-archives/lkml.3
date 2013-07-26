Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab3GZMFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:05:04 -0400
Received: from mout.gmx.net ([212.227.15.18]:50555 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151Ab3GZMFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:05:02 -0400
Date: Fri, 26 Jul 2013 14:04:55 +0200
From: Michael Brunner <mibru@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Chris Healy <chealy@imsco-us.com>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Subject: [PATCH] i2c: Fix Kontron PLD prescaler calculation
Message-ID: <20130726140455.40b4b86b@hyperion>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:zDTq8rqA8A4qvJBSiDZLxj5XLY+2sjvjMeVW8QWKW0VHgyArw1X
 RnTKvrcsjscAnNtdZXnXGMb48AoIDgAfMZeMLgPRopJOwTTQt4zVer1nLJ4t3z3kac3oCLk
 6MzCytoYG1XnLFDzqY4CDe3WBow4VtldNEVnfz0k1k4Yku0DBAVveksA65xgrrNBrzOlBPj
 rzpei7rcICz7jDEFvChlg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some necessary braces that have been removed during driver cleanup.
This fixes the I2C prescaler calculation.

Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
---
 drivers/i2c/busses/i2c-kempld.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-kempld.c b/drivers/i2c/busses/i2c-kempld.c
index ccec916..af8f65f 100644
--- a/drivers/i2c/busses/i2c-kempld.c
+++ b/drivers/i2c/busses/i2c-kempld.c
@@ -246,9 +246,9 @@ static void kempld_i2c_device_init(struct kempld_i2c_data *i2c)
 		bus_frequency = KEMPLD_I2C_FREQ_MAX;
 
 	if (pld->info.spec_major == 1)
-		prescale = pld->pld_clock / bus_frequency * 5 - 1000;
+		prescale = pld->pld_clock / (bus_frequency * 5) - 1000;
 	else
-		prescale = pld->pld_clock / bus_frequency * 4 - 3000;
+		prescale = pld->pld_clock / (bus_frequency * 4) - 3000;
 
 	if (prescale < 0)
 		prescale = 0;
