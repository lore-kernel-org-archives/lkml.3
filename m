Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaKKLJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:09:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57129 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaKKLJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Canek=20Pel=C3=A1ez=20Vald=C3=A9s?= 
	<canek@ciencias.unam.mx>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 007/170] rt2x00: support Ralink 5362.
Date: Tue, 11 Nov 2014 11:06:06 +0000
Message-Id: <1415704129-12709-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Canek=20Pel=C3=A1ez=20Vald=C3=A9s?= <canek@ciencias.unam.mx>

commit ac0372abf8524a7572a9cdaac6495eb2eba20457 upstream.

Signed-off-by: Canek Peláez Valdés <canek@ciencias.unam.mx>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2800.h    | 4 +++-
 drivers/net/wireless/rt2x00/rt2800lib.c | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 7cf6081a05a1..ebd5625d13f1 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -52,6 +52,7 @@
  * RF5592 2.4G/5G 2T2R
  * RF3070 2.4G 1T1R
  * RF5360 2.4G 1T1R
+ * RF5362 2.4G 1T1R
  * RF5370 2.4G 1T1R
  * RF5390 2.4G 1T1R
  */
@@ -72,6 +73,7 @@
 #define RF3070				0x3070
 #define RF3290				0x3290
 #define RF5360				0x5360
+#define RF5362				0x5362
 #define RF5370				0x5370
 #define RF5372				0x5372
 #define RF5390				0x5390
@@ -2145,7 +2147,7 @@ struct mac_iveiv_entry {
 /* Bits [7-4] for RF3320 (RT3370/RT3390), on other chipsets reserved */
 #define RFCSR3_PA1_BIAS_CCK		FIELD8(0x70)
 #define RFCSR3_PA2_CASCODE_BIAS_CCKK	FIELD8(0x80)
-/* Bits for RF3290/RF5360/RF5370/RF5372/RF5390/RF5392 */
+/* Bits for RF3290/RF5360/RF5362/RF5370/RF5372/RF5390/RF5392 */
 #define RFCSR3_VCOCAL_EN		FIELD8(0x80)
 /* Bits for RF3050 */
 #define RFCSR3_BIT1			FIELD8(0x02)
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c17fcf272728..56e9b58b0158 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3141,6 +3141,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		break;
 	case RF3070:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -3158,6 +3159,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	    rt2x00_rf(rt2x00dev, RF3290) ||
 	    rt2x00_rf(rt2x00dev, RF3322) ||
 	    rt2x00_rf(rt2x00dev, RF5360) ||
+	    rt2x00_rf(rt2x00dev, RF5362) ||
 	    rt2x00_rf(rt2x00dev, RF5370) ||
 	    rt2x00_rf(rt2x00dev, RF5372) ||
 	    rt2x00_rf(rt2x00dev, RF5390) ||
@@ -4272,6 +4274,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 	case RF3070:
 	case RF3290:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -7072,6 +7075,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF3320:
 	case RF3322:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -7528,6 +7532,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3320:
 	case RF3322:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -7657,6 +7662,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3070:
 	case RF3290:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
-- 
2.1.0

