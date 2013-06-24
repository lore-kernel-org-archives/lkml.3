Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3GCLbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 07:31:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35843 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3GCLbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 07:31:08 -0400
X-AuditID: cbfee68e-b7f276d000002279-09-51d40b79745c
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: yadi.brar01@gmail.com, sbkim73@samsung.com, broonie@kernel.org,
        lgirdwood@gmail.com, sameo@linux.intel.com, rob.herring@calxeda.com,
        grant.likely@linaro.org, Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 1/4] regulator: s2mps11: Convert ramp rate to uV/us and set
 default ramp rate
Date: Mon, 24 Jun 2013 16:50:55 +0530
Message-id: <1372072858-6559-2-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSq1vJfSXQ4M4pS4upD5+wWRz4s4PR
	4tuVDiaLy7vmsFkcXnGAyeJ0N6vFxRVfmCzm/m5ktZgz/R2TA6fHgs9X2D12zrrL7rFpVSeb
	x51re9g85p0M9OjbsorR4/MmuQD2KC6blNSczLLUIn27BK6MF72TWQquSlY8uPiCuYHxjUgX
	IyeHhICJxPrts9ghbDGJC/fWs3UxcnEICSxllDi2r48Fpuj4sldMEInpjBKbLm5gh3DamCTO
	Pepm7GLk4GATMJJ4dcwOpEFEQEFic+8zVpAaZoFLjBLT9h5hBUkIC8RLLOndyQxiswioSmx/
	OpcJxOYVcJHYtKUP6gwFidZlh8BsTgFXidaXF5hB5gsB1TR/ZAGZKSGwi11i2YvHTBBzBCS+
	TT7EAlIjISArsekAM8QYSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMj
	MBZO/3vWt4Px5gHrQ4zJQOMmMkuJJucDYymvJN7Q2MzIwtTE1NjI3NKMNGElcV61FutAIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyljc82fsq93/Iuc8LhqmcKjjvrq9ewOc3+m9h2wvmT
	9Pc1+53147ql9KotdAusPlqZz6wwO+UdqeRi0f10F7v6HMGi7xMWr9VTP1aRrrtQ6EpW4L9l
	bTdmaD3cZqStd9o/IC+a6eocD8liPueZT2TFGNJereVeZX+guEx3pevEjbzz3Oq9gpRYijMS
	DbWYi4oTAZCIpKibAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd1K7iuBBu+f6FtMffiEzeLAnx2M
	Ft+udDBZXN41h83i8IoDTBanu1ktLq74wmQx93cjq8Wc6e+YHDg9Fny+wu6xc9Zddo9NqzrZ
	PO5c28PmMe9koEffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpa
	WpgrKeQl5qbaKrn4BOi6ZeYAXaakUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAAN
	JKxhzHjRO5ml4KpkxYOLL5gbGN+IdDFyckgImEgcX/aKCcIWk7hwbz1bFyMXh5DAdEaJTRc3
	sEM4bUwS5x51M3YxcnCwCRhJvDpmB9IgIqAgsbn3GStIDbPAJUaJaXuPsIIkhAXiJZb07mQG
	sVkEVCW2P50LtoFXwEVi05Y+dohtChKtyw6B2ZwCrhKtLy8wg8wXAqpp/sgygZF3ASPDKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYzgSHsmvYNxVYPFIUYBDkYlHl6HZ5cChVgTy4orcw8x
	SnAwK4nwTvxzOVCINyWxsiq1KD++qDQntfgQYzLQUROZpUST84FJIK8k3tDYxNzU2NTSxMLE
	zJI0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGMtN/COLsn0rBVe9m3xXVv5h4zoFh1xL
	RpvMoge3d22Ov+Q/L3SOV0z/rl5fOUXmRzdcXsocbLle69fkMdF8QX7XR18Rk4vbC6x1o068
	3/myb1HeMeX6Bef7n/it2HPEpvgqm8MT9VsfWd8UzzuvXpvblOr0UTPPqfx3UPgH1cz3k9ru
	fw3cqsRSnJFoqMVcVJwIAHC+r9f4AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes driver to use uV/us as units of ramp_delay. It makes driver
in compliance with regulator framework and make ramp rate precise.

This patch also sets default ramp rate in regulator descriptor which can be
used in case if case ramp rate is not set in regulator constraints.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 drivers/regulator/s2mps11.c         |    7 ++++++-
 include/linux/mfd/samsung/s2mps11.h |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index cd9ea2e..0ec9aea 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -43,7 +43,7 @@ static int get_ramp_delay(int ramp_delay)
 {
 	unsigned char cnt = 0;
 
-	ramp_delay /= 6;
+	ramp_delay /= 6250;
 
 	while (true) {
 		ramp_delay = ramp_delay >> 1;
@@ -114,6 +114,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.min_uV		= S2MPS11_BUCK_MIN1,			\
 	.uV_step	= S2MPS11_BUCK_STEP1,			\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
 	.vsel_reg	= S2MPS11_REG_B1CTRL2 + (num - 1) * 2,	\
 	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
 	.enable_reg	= S2MPS11_REG_B1CTRL1 + (num - 1) * 2,	\
@@ -129,6 +130,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.min_uV		= S2MPS11_BUCK_MIN1,			\
 	.uV_step	= S2MPS11_BUCK_STEP1,			\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
 	.vsel_reg	= S2MPS11_REG_B5CTRL2,			\
 	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
 	.enable_reg	= S2MPS11_REG_B5CTRL1,			\
@@ -144,6 +146,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.min_uV		= S2MPS11_BUCK_MIN1,			\
 	.uV_step	= S2MPS11_BUCK_STEP1,			\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
 	.vsel_reg	= S2MPS11_REG_B6CTRL2 + (num - 6) * 2,	\
 	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
 	.enable_reg	= S2MPS11_REG_B6CTRL1 + (num - 6) * 2,	\
@@ -159,6 +162,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.min_uV		= S2MPS11_BUCK_MIN3,			\
 	.uV_step	= S2MPS11_BUCK_STEP3,			\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
 	.vsel_reg	= S2MPS11_REG_B9CTRL2,			\
 	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
 	.enable_reg	= S2MPS11_REG_B9CTRL1,			\
@@ -174,6 +178,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.min_uV		= S2MPS11_BUCK_MIN2,			\
 	.uV_step	= S2MPS11_BUCK_STEP2,			\
 	.n_voltages	= S2MPS11_BUCK_N_VOLTAGES,		\
+	.ramp_delay	= S2MPS11_RAMP_DELAY,			\
 	.vsel_reg	= S2MPS11_REG_B10CTRL2,			\
 	.vsel_mask	= S2MPS11_BUCK_VSEL_MASK,		\
 	.enable_reg	= S2MPS11_REG_B10CTRL1,			\
diff --git a/include/linux/mfd/samsung/s2mps11.h b/include/linux/mfd/samsung/s2mps11.h
index ad2252f..4e94dc6 100644
--- a/include/linux/mfd/samsung/s2mps11.h
+++ b/include/linux/mfd/samsung/s2mps11.h
@@ -189,6 +189,7 @@ enum s2mps11_regulators {
 #define S2MPS11_ENABLE_SHIFT	0x06
 #define S2MPS11_LDO_N_VOLTAGES	(S2MPS11_LDO_VSEL_MASK + 1)
 #define S2MPS11_BUCK_N_VOLTAGES (S2MPS11_BUCK_VSEL_MASK + 1)
+#define S2MPS11_RAMP_DELAY	25000		/* uV/us */
 
 #define S2MPS11_PMIC_EN_SHIFT	6
 #define S2MPS11_REGULATOR_MAX (S2MPS11_REG_MAX - 3)
-- 
1.7.0.4

