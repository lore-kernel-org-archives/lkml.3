Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaLAFGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 00:06:16 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:58763 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaLAFGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 00:06:14 -0500
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: change some printk calls to pr_err
Date: Sun, 30 Nov 2014 23:05:56 -0600
Message-Id: <1417410356-25504-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a handful of calls to printk in ni_stc.h without specified log
levels, as well as one in ni_mio_common.c.  This patch converts these
calls to pr_err() instead, so that they are now explicitly log level
ERR.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
---
I tacked the change to ni_mio_common.c on to this patch since it's the same
exact change and it's just one line, so I think a single patch is justified
here.
 drivers/staging/comedi/drivers/ni_mio_common.c |  2 +-
 drivers/staging/comedi/drivers/ni_stc.h        | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 353c17b..11e7017 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -3945,7 +3945,7 @@ static unsigned ni_gpct_to_stc_register(enum ni_gpct_register reg)
 		stc_register = Interrupt_B_Enable_Register;
 		break;
 	default:
-		printk("%s: unhandled register 0x%x in switch.\n",
+		pr_err("%s: unhandled register 0x%x in switch.\n",
 		       __func__, reg);
 		BUG();
 		return 0;
diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
index 131e904..bd69c3f 100644
--- a/drivers/staging/comedi/drivers/ni_stc.h
+++ b/drivers/staging/comedi/drivers/ni_stc.h
@@ -334,7 +334,7 @@ static inline unsigned RTSI_Output_Bit(unsigned channel, int is_mseries)
 		max_channel = 6;
 	}
 	if (channel > max_channel) {
-		printk("%s: bug, invalid RTSI_channel=%i\n", __func__, channel);
+		pr_err("%s: bug, invalid RTSI_channel=%i\n", __func__, channel);
 		return 0;
 	}
 	return 1 << (base_bit_shift + channel);
@@ -1090,7 +1090,7 @@ static inline int M_Offset_Static_AI_Control(int i)
 		0x263,
 	};
 	if (((unsigned)i) >= ARRAY_SIZE(offset)) {
-		printk("%s: invalid channel=%i\n", __func__, i);
+		pr_err("%s: invalid channel=%i\n", __func__, i);
 		return offset[0];
 	}
 	return offset[i];
@@ -1105,7 +1105,7 @@ static inline int M_Offset_AO_Reference_Attenuation(int channel)
 		0x267
 	};
 	if (((unsigned)channel) >= ARRAY_SIZE(offset)) {
-		printk("%s: invalid channel=%i\n", __func__, channel);
+		pr_err("%s: invalid channel=%i\n", __func__, channel);
 		return offset[0];
 	}
 	return offset[channel];
@@ -1114,7 +1114,7 @@ static inline int M_Offset_AO_Reference_Attenuation(int channel)
 static inline unsigned M_Offset_PFI_Output_Select(unsigned n)
 {
 	if (n < 1 || n > NUM_PFI_OUTPUT_SELECT_REGS) {
-		printk("%s: invalid pfi output select register=%i\n",
+		pr_err("%s: invalid pfi output select register=%i\n",
 		       __func__, n);
 		return M_Offset_PFI_Output_Select_1;
 	}
@@ -1171,7 +1171,7 @@ static inline unsigned MSeries_PLL_In_Source_Select_RTSI_Bits(unsigned
 							      RTSI_channel)
 {
 	if (RTSI_channel > 7) {
-		printk("%s: bug, invalid RTSI_channel=%i\n", __func__,
+		pr_err("%s: bug, invalid RTSI_channel=%i\n", __func__,
 		       RTSI_channel);
 		return 0;
 	}
@@ -1192,7 +1192,7 @@ static inline unsigned MSeries_PLL_Divisor_Bits(unsigned divisor)
 {
 	static const unsigned max_divisor = 0x10;
 	if (divisor < 1 || divisor > max_divisor) {
-		printk("%s: bug, invalid divisor=%i\n", __func__, divisor);
+		pr_err("%s: bug, invalid divisor=%i\n", __func__, divisor);
 		return 0;
 	}
 	return (divisor & 0xf) << 8;
@@ -1202,7 +1202,7 @@ static inline unsigned MSeries_PLL_Multiplier_Bits(unsigned multiplier)
 {
 	static const unsigned max_multiplier = 0x100;
 	if (multiplier < 1 || multiplier > max_multiplier) {
-		printk("%s: bug, invalid multiplier=%i\n", __func__,
+		pr_err("%s: bug, invalid multiplier=%i\n", __func__,
 		       multiplier);
 		return 0;
 	}
-- 
2.1.3

