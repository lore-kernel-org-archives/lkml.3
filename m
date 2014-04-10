Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272AbaDJDlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:41:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935095AbaDJDW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 113/134] hwmon: (coretemp) Add support for Atom D2000 and N2000 series CPU models
Date: Wed,  9 Apr 2014 20:23:49 -0700
Message-Id: <20140410032313.946626806@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 5592906f8b01282ea3c2acaf641fd067ad4bb3dc upstream.

Document the Atom series D2000 and N2000 (Cedar Trail) as being supported.
List and set TjMax for those series.

Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "R, Durgadoss" <durgadoss.r@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/hwmon/coretemp |    5 ++++-
 drivers/hwmon/coretemp.c     |    3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/Documentation/hwmon/coretemp
+++ b/Documentation/hwmon/coretemp
@@ -7,7 +7,8 @@ Supported chips:
     CPUID: family 0x6, models 0xe (Pentium M DC), 0xf (Core 2 DC 65nm),
                               0x16 (Core 2 SC 65nm), 0x17 (Penryn 45nm),
                               0x1a (Nehalem), 0x1c (Atom), 0x1e (Lynnfield),
-                              0x26 (Tunnel Creek Atom), 0x27 (Medfield Atom)
+                              0x26 (Tunnel Creek Atom), 0x27 (Medfield Atom),
+                              0x36 (Cedar Trail Atom)
     Datasheet: Intel 64 and IA-32 Architectures Software Developer's Manual
                Volume 3A: System Programming Guide
                http://softwarecommunity.intel.com/Wiki/Mobility/720.htm
@@ -68,6 +69,8 @@ Process		Processor					TjMax(C)
 
 32nm		Atom Processors
 		Z2460						90
+		D2700/2550/2500					100
+		N2850/2800/2650/2600				100
 
 45nm		Xeon Processors 5400 Quad-Core
 		X5492, X5482, X5472, X5470, X5460, X5450	85
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -224,6 +224,9 @@ static int __cpuinit adjust_tjmax(struct
 			tjmax = 90000;
 
 		pci_dev_put(host_bridge);
+	} else if (c->x86_model == 0x36) {
+		usemsr_ee = 0;
+		tjmax = 100000;
 	}
 
 	if (c->x86_model > 0xe && usemsr_ee) {


