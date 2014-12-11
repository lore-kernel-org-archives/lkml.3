Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaLKMjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 07:39:22 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31690 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaLKMjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 07:39:19 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-bc-54899074cabc
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] regulator: s2mps11: Fix dwmmc failure on Gear 2
Date: Thu, 11 Dec 2014 13:39:11 +0100
Message-id: <1418301551-31678-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMJMWRmVeSWpSXmKPExsVy+t/xq7olEzpDDGa+ULKY+vAJm8XrF4YW
	3650MFlc3jWHzeLiii9MFgs2PmJ0YPPYOesuu8emVZ1sHn1bVjF6fN4kF8ASxWWTkpqTWZZa
	pG+XwJUxac0RtoIGtYpnh84yNTD+le9i5OSQEDCRmD3jLTOELSZx4d56ti5GLg4hgaWMEtt+
	3GOFcPqYJNY+bGYCqWITMJbYvHwJWJWIQA+jxMutn8HamQU8Jd79fcjexcjBISzgIHH4niFI
	mEVAVeLO151gJbwC7hK7Vx1lg9gmJ3Hy2GTWCYzcCxgZVjGKppYmFxQnpeca6hUn5haX5qXr
	JefnbmKEBMSXHYyLj1kdYhTgYFTi4RWI7QwRYk0sK67MPcQowcGsJMJrFQEU4k1JrKxKLcqP
	LyrNSS0+xMjEwSnVwKjNua58y75sM6/HX72e5s8LtNRRfZMU9s7YQ15iZ3bt+cm6WqZ77Nee
	vcGfb8SVIC75brt9VOXBrj05HmwLG9jidZz/WvE5VT28k7z8Q6jByzeJEwXy/h5OUr2lUpRd
	afKicu25faY/at60J7+5cav8wemQj2d31/z89Mut8KS6yBefyE8OpkosxRmJhlrMRcWJADWX
	AcXmAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invalid buck4 configuration in S2MPS14 regulators caused boot failure on
Gear 2 (dwmmc_exynos):

[    3.569137] EXT4-fs (mmcblk0p15): mounted filesystem with ordered data mode. Opts: (null)
[    3.571716] VFS: Mounted root (ext4 filesystem) readonly on device 179:15.
[    3.580836] devtmpfs: mounted
[    3.582033] Freeing unused kernel memory: 284K (c05b4000 - c05fb000)
[    3.629842] mmcblk0: error -110 sending status command, retrying
[    3.630244] mmcblk0: error -110 sending status command, retrying
[    3.636292] mmcblk0: error -110 sending status command, aborting
[    3.642279] end_request: I/O error, dev mmcblk0, sector 7302680
[    3.648128] end_request: I/O error, dev mmcblk0, sector 7302688
[    3.654025] end_request: I/O error, dev mmcblk0, sector 7302696
[    3.659927] end_request: I/O error, dev mmcblk0, sector 7302704
[    3.665829] end_request: I/O error, dev mmcblk0, sector 7302712
[    3.671731] end_request: I/O error, dev mmcblk0, sector 7302720
[    3.677635] end_request: I/O error, dev mmcblk0, sector 7302728
[    3.683536] end_request: I/O error, dev mmcblk0, sector 7302736
[    3.689438] end_request: I/O error, dev mmcblk0, sector 7302744
[    3.695339] end_request: I/O error, dev mmcblk0, sector 7302752
[    3.701445] mmcblk0: error -110 sending status command, retrying
[    3.707262] mmcblk0: error -110 sending status command, retrying
[    3.713248] mmcblk0: error -110 sending status command, aborting
[    3.727704] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000007
[    3.727704]
[    3.731205] CPU: 0 PID: 1 Comm: init Not tainted 3.17.0-rc1-00003-g5a867cf28893 #1183
[    3.739042] [<c0013b04>] (unwind_backtrace) from [<c0010dcc>] (show_stack+0x10/0x14)
[    3.746750] [<c0010dcc>] (show_stack) from [<c0414aa0>] (dump_stack+0x70/0xbc)
[    3.753952] [<c0414aa0>] (dump_stack) from [<c04122d4>] (panic+0x90/0x1fc)
[    3.760810] [<c04122d4>] (panic) from [<c0022f68>] (do_exit+0x834/0x8b0)
[    3.767492] [<c0022f68>] (do_exit) from [<c00230d0>] (do_group_exit+0x3c/0xb0)
[    3.774698] [<c00230d0>] (do_group_exit) from [<c002b734>] (get_signal+0x1dc/0x57c)
[    3.782333] [<c002b734>] (get_signal) from [<c0411d70>] (do_signal+0x84/0x3a4)
[    3.789537] [<c0411d70>] (do_signal) from [<c001093c>] (do_work_pending+0x84/0xc4)
[    3.797089] [<c001093c>] (do_work_pending) from [<c000e660>] (work_pending+0xc/0x20)
[    3.804812] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000007

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 5a867cf28893 ("regulator: s2mps11: Optimize the regulator description macro")
Cc: <stable@vger.kernel.org>
---
 drivers/regulator/s2mps11.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index c1444c3d84c2..9051ce6629d3 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -570,7 +570,7 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.enable_mask	= S2MPS14_ENABLE_MASK		\
 }
 
-#define regulator_desc_s2mps14_buck(num, min, step) {		\
+#define regulator_desc_s2mps14_buck(num, min, step, min_sel) {	\
 	.name		= "BUCK"#num,				\
 	.id		= S2MPS14_BUCK##num,			\
 	.ops		= &s2mps14_reg_ops,			\
@@ -579,7 +579,7 @@ static struct regulator_ops s2mps14_reg_ops = {
 	.min_uV		= min,					\
 	.uV_step	= step,					\
 	.n_voltages	= S2MPS14_BUCK_N_VOLTAGES,		\
-	.linear_min_sel = S2MPS14_BUCK1235_START_SEL,		\
+	.linear_min_sel = min_sel,				\
 	.ramp_delay	= S2MPS14_BUCK_RAMP_DELAY,		\
 	.vsel_reg	= S2MPS14_REG_B1CTRL2 + (num - 1) * 2,	\
 	.vsel_mask	= S2MPS14_BUCK_VSEL_MASK,		\
@@ -613,11 +613,16 @@ static const struct regulator_desc s2mps14_regulators[] = {
 	regulator_desc_s2mps14_ldo(23, MIN_800_MV, STEP_25_MV),
 	regulator_desc_s2mps14_ldo(24, MIN_1800_MV, STEP_25_MV),
 	regulator_desc_s2mps14_ldo(25, MIN_1800_MV, STEP_25_MV),
-	regulator_desc_s2mps14_buck(1, MIN_600_MV, STEP_6_25_MV),
-	regulator_desc_s2mps14_buck(2, MIN_600_MV, STEP_6_25_MV),
-	regulator_desc_s2mps14_buck(3, MIN_600_MV, STEP_6_25_MV),
-	regulator_desc_s2mps14_buck(4, MIN_1400_MV, STEP_12_5_MV),
-	regulator_desc_s2mps14_buck(5, MIN_600_MV, STEP_6_25_MV),
+	regulator_desc_s2mps14_buck(1, MIN_600_MV, STEP_6_25_MV,
+			S2MPS14_BUCK1235_START_SEL),
+	regulator_desc_s2mps14_buck(2, MIN_600_MV, STEP_6_25_MV,
+			S2MPS14_BUCK1235_START_SEL),
+	regulator_desc_s2mps14_buck(3, MIN_600_MV, STEP_6_25_MV,
+			S2MPS14_BUCK1235_START_SEL),
+	regulator_desc_s2mps14_buck(4, MIN_1400_MV, STEP_12_5_MV,
+			S2MPS14_BUCK4_START_SEL),
+	regulator_desc_s2mps14_buck(5, MIN_600_MV, STEP_6_25_MV,
+			S2MPS14_BUCK1235_START_SEL),
 };
 
 static int s2mps14_pmic_enable_ext_control(struct s2mps11_info *s2mps11,
-- 
1.9.1

