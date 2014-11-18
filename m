Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbaKRO3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:29:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbaKROKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Canek=20Pel=C3=A1ez=20Vald=C3=A9s?= 
	<canek@ciencias.unam.mx>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 151/206] rt2x00: support Ralink 5362.
Date: Tue, 18 Nov 2014 15:08:26 +0100
Message-Id: <8237ba542301c82a86768dbb814d34226ade79b4.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Canek Peláez Valdés <canek@ciencias.unam.mx>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ac0372abf8524a7572a9cdaac6495eb2eba20457 upstream.

Signed-off-by: Canek Peláez Valdés <canek@ciencias.unam.mx>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/rt2x00/rt2800.h    | 4 +++-
 drivers/net/wireless/rt2x00/rt2800lib.c | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index bc82d55d77c0..71f70c724fc9 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -54,6 +54,7 @@
  * RF5592 2.4G/5G 2T2R
  * RF3070 2.4G 1T1R
  * RF5360 2.4G 1T1R
+ * RF5362 2.4G 1T1R
  * RF5370 2.4G 1T1R
  * RF5390 2.4G 1T1R
  */
@@ -74,6 +75,7 @@
 #define RF3070				0x3070
 #define RF3290				0x3290
 #define RF5360				0x5360
+#define RF5362				0x5362
 #define RF5370				0x5370
 #define RF5372				0x5372
 #define RF5390				0x5390
@@ -2147,7 +2149,7 @@ struct mac_iveiv_entry {
 /* Bits [7-4] for RF3320 (RT3370/RT3390), on other chipsets reserved */
 #define RFCSR3_PA1_BIAS_CCK		FIELD8(0x70)
 #define RFCSR3_PA2_CASCODE_BIAS_CCKK	FIELD8(0x80)
-/* Bits for RF3290/RF5360/RF5370/RF5372/RF5390/RF5392 */
+/* Bits for RF3290/RF5360/RF5362/RF5370/RF5372/RF5390/RF5392 */
 #define RFCSR3_VCOCAL_EN		FIELD8(0x80)
 /* Bits for RF3050 */
 #define RFCSR3_BIT1			FIELD8(0x02)
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 446eadeaaef6..3bbd03c4906d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3154,6 +3154,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		break;
 	case RF3070:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -3171,6 +3172,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	    rt2x00_rf(rt2x00dev, RF3290) ||
 	    rt2x00_rf(rt2x00dev, RF3322) ||
 	    rt2x00_rf(rt2x00dev, RF5360) ||
+	    rt2x00_rf(rt2x00dev, RF5362) ||
 	    rt2x00_rf(rt2x00dev, RF5370) ||
 	    rt2x00_rf(rt2x00dev, RF5372) ||
 	    rt2x00_rf(rt2x00dev, RF5390) ||
@@ -4269,6 +4271,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 	case RF3070:
 	case RF3290:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -7032,6 +7035,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF3320:
 	case RF3322:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
@@ -7555,6 +7559,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		   rt2x00_rf(rt2x00dev, RF3320) ||
 		   rt2x00_rf(rt2x00dev, RF3322) ||
 		   rt2x00_rf(rt2x00dev, RF5360) ||
+		   rt2x00_rf(rt2x00dev, RF5362) ||
 		   rt2x00_rf(rt2x00dev, RF5370) ||
 		   rt2x00_rf(rt2x00dev, RF5372) ||
 		   rt2x00_rf(rt2x00dev, RF5390) ||
@@ -7682,6 +7687,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3070:
 	case RF3290:
 	case RF5360:
+	case RF5362:
 	case RF5370:
 	case RF5372:
 	case RF5390:
-- 
2.1.3

