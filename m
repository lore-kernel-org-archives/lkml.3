Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935286AbaDJDmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:42:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935086AbaDJDWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 112/134] hwmon: (coretemp) Improve support of recent Atom CPU models
Date: Wed,  9 Apr 2014 20:23:48 -0700
Message-Id: <20140410032313.888327642@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit fcc14ac1a86931f38da047cf8fb634c6db7b58bc upstream.

Document the new Atom series (Tunnel Creek and Medfield) as being
supported, and list TjMax for the Atom E600 series.

Also enable the Atom tjmax heuristic for these Atom CPU models.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Reviewed-by: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "R, Durgadoss" <durgadoss.r@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/hwmon/coretemp |    8 +++++++-
 drivers/hwmon/coretemp.c     |    3 ++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/Documentation/hwmon/coretemp
+++ b/Documentation/hwmon/coretemp
@@ -6,7 +6,8 @@ Supported chips:
     Prefix: 'coretemp'
     CPUID: family 0x6, models 0xe (Pentium M DC), 0xf (Core 2 DC 65nm),
                               0x16 (Core 2 SC 65nm), 0x17 (Penryn 45nm),
-                              0x1a (Nehalem), 0x1c (Atom), 0x1e (Lynnfield)
+                              0x1a (Nehalem), 0x1c (Atom), 0x1e (Lynnfield),
+                              0x26 (Tunnel Creek Atom), 0x27 (Medfield Atom)
     Datasheet: Intel 64 and IA-32 Architectures Software Developer's Manual
                Volume 3A: System Programming Guide
                http://softwarecommunity.intel.com/Wiki/Mobility/720.htm
@@ -65,6 +66,9 @@ Process		Processor					TjMax(C)
 		U3400						105
 		P4505/P4500 					90
 
+32nm		Atom Processors
+		Z2460						90
+
 45nm		Xeon Processors 5400 Quad-Core
 		X5492, X5482, X5472, X5470, X5460, X5450	85
 		E5472, E5462, E5450/40/30/20/10/05		85
@@ -85,6 +89,8 @@ Process		Processor					TjMax(C)
 		N475/470/455/450				100
 		N280/270					90
 		330/230						125
+		E680/660/640/620				90
+		E680T/660T/640T/620T				110
 
 45nm		Core2 Processors
 		Solo ULV SU3500/3300				100
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -210,7 +210,8 @@ static int __cpuinit adjust_tjmax(struct
 
 	/* Atom CPUs */
 
-	if (c->x86_model == 0x1c) {
+	if (c->x86_model == 0x1c || c->x86_model == 0x26
+	    || c->x86_model == 0x27) {
 		usemsr_ee = 0;
 
 		host_bridge = pci_get_bus_and_slot(0, PCI_DEVFN(0, 0));


