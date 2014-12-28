Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaL1S4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 13:56:45 -0500
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:43136 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758AbaL1S4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 13:56:41 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Andreas Siegling <andreas.siegling@fau.de>
To: devel@linuxdriverproject.org
Cc: linux-kernel@i4.cs.fau.de, hsweeten@visionengravers.com, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ebru.akagunduz@gmail.com,
        chase.southwood@gmail.com, rickard_strandqvist@spectrumdigital.se,
        Andreas Siegling <andreas.siegling@fau.de>,
        Zhutao Lu <lvzhutao@gmail.com>
Subject: [PATCH 3/3] comedi: checkpatch warning: missing blank line
Date: Sun, 28 Dec 2014 19:56:15 +0100
Message-Id: <1419792975-31519-4-git-send-email-andreas.siegling@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419792975-31519-1-git-send-email-andreas.siegling@fau.de>
References: <1419792975-31519-1-git-send-email-andreas.siegling@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will fix all occurrences of the checkpatch warning:
	 WARNING: Missing a blank line after declarations
in drivers/staging/comedi/.

Signed-off-by: Andreas Siegling <andreas.siegling@fau.de>
Signed-off-by: Zhutao Lu <lvzhutao@gmail.com>
---
 drivers/staging/comedi/drivers/comedi_bond.c | 1 +
 drivers/staging/comedi/drivers/ni_stc.h      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 85b2f4a..221d381 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -261,6 +261,7 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
 			{
 				/* Append dev:subdev to devpriv->name */
 				char buf[20];
+
 				snprintf(buf, sizeof(buf), "%u:%u ",
 					 bdev->minor, bdev->subdev);
 				strlcat(devpriv->name, buf,
diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
index bb76fe1..3b8b3c5 100644
--- a/drivers/staging/comedi/drivers/ni_stc.h
+++ b/drivers/staging/comedi/drivers/ni_stc.h
@@ -326,6 +326,7 @@ static inline unsigned RTSI_Output_Bit(unsigned channel, int is_mseries)
 {
 	unsigned max_channel;
 	unsigned base_bit_shift;
+
 	if (is_mseries) {
 		base_bit_shift = 8;
 		max_channel = 7;
@@ -1142,6 +1143,7 @@ static inline unsigned MSeries_AI_Config_Bank_Bits(enum ni_reg_type reg_type,
 						   unsigned channel)
 {
 	unsigned bits = channel & 0x30;
+
 	if (reg_type == ni_reg_622x) {
 		if (channel & 0x40)
 			bits |= 0x400;
@@ -1191,6 +1193,7 @@ enum MSeries_PLL_Control_Bits {
 static inline unsigned MSeries_PLL_Divisor_Bits(unsigned divisor)
 {
 	static const unsigned max_divisor = 0x10;
+
 	if (divisor < 1 || divisor > max_divisor) {
 		pr_err("%s: bug, invalid divisor=%i\n", __func__, divisor);
 		return 0;
@@ -1201,6 +1204,7 @@ static inline unsigned MSeries_PLL_Divisor_Bits(unsigned divisor)
 static inline unsigned MSeries_PLL_Multiplier_Bits(unsigned multiplier)
 {
 	static const unsigned max_multiplier = 0x100;
+
 	if (multiplier < 1 || multiplier > max_multiplier) {
 		pr_err("%s: bug, invalid multiplier=%i\n", __func__,
 		       multiplier);
-- 
1.9.1

