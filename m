Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbaCKVVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:21:35 -0400
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:14828
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751412AbaCKVVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:21:33 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VPS2(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2iz1de098h177df4h8275eh17326ah8275bh8275dh1de097h186068ha1495iz2dh839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
X-WSS-ID: 0N2AJBP-08-6Z8-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <clemens@ladisch.de>, <jdelvare@suse.de>, <linux@roeck-us.net>,
        <rob@landley.net>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <andre@andrep.de>, Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] hwmon, k10temp: Add support for AMD F16 M30h processor
Date: Tue, 11 Mar 2014 16:25:59 -0500
Message-ID: <1394573159-2317-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding new PCI ID to support AMD F16 M30h processor (Mullins).
While at it, modify Kconfig and Doc files to reflect the
support for newer processors

Note: PCI ID for this processor will make it into pci_ids.h
as part of this patch:
http://marc.info/?l=linux-kernel&m=139291362126057&w=2
which should be pulled into 3.15 when merge window opens
(It currently sits in 'for-next' branch of bp.git-
https://git.kernel.org/cgit/linux/kernel/git/bp/bp.git/log/?h=for-next)

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 Documentation/hwmon/k10temp | 6 +++---
 drivers/hwmon/Kconfig       | 4 ++--
 drivers/hwmon/k10temp.c     | 1 +
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/hwmon/k10temp b/Documentation/hwmon/k10temp
index 4dfdc8f..ee6d30e 100644
--- a/Documentation/hwmon/k10temp
+++ b/Documentation/hwmon/k10temp
@@ -11,8 +11,8 @@ Supported chips:
   Socket S1G2: Athlon (X2), Sempron (X2), Turion X2 (Ultra)
 * AMD Family 12h processors: "Llano" (E2/A4/A6/A8-Series)
 * AMD Family 14h processors: "Brazos" (C/E/G/Z-Series)
-* AMD Family 15h processors: "Bulldozer" (FX-Series), "Trinity"
-* AMD Family 16h processors: "Kabini"
+* AMD Family 15h processors: "Bulldozer" (FX-Series), "Trinity", "Kaveri"
+* AMD Family 16h processors: "Kabini", "Mullins"
 
   Prefix: 'k10temp'
   Addresses scanned: PCI space
@@ -46,7 +46,7 @@ Description
 -----------
 
 This driver permits reading of the internal temperature sensor of AMD
-Family 10h/11h/12h/14h/15h processors.
+Family 10h/11h/12h/14h/15h/16h processors.
 
 All these processors have a sensor, but on those for Socket F or AM2+,
 the sensor may return inconsistent values (erratum 319).  The driver
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 5ce43d8..83db056 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -296,8 +296,8 @@ config SENSORS_K10TEMP
 	  If you say yes here you get support for the temperature
 	  sensor(s) inside your CPU. Supported are later revisions of
 	  the AMD Family 10h and all revisions of the AMD Family 11h,
-	  12h (Llano), 14h (Brazos), 15h (Bulldozer/Trinity) and
-	  16h (Kabini) microarchitectures.
+	  12h (Llano), 14h (Brazos), 15h (Bulldozer/Trinity/Kaveri) and
+	  16h (Kabini/Mullins) microarchitectures.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called k10temp.
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index baf375b..f7b46f6 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -212,6 +212,7 @@ static const struct pci_device_id k10temp_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, k10temp_id_table);
-- 
1.8.1.2


