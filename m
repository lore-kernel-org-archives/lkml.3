Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaLSFdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 00:33:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43949 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaLSFc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 00:32:59 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-f5-5493b888c3fc
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will.deacon@arm.com, lorenzo.pieralisi@arm.com,
        mark.rutland@arm.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] arm64: psci: Support generic pm suspend withtout CPUIDLE
 subsystem's help.
Date: Fri, 19 Dec 2014 14:32:54 +0900
Message-id: <1418967174-23943-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsWyRsSkULdzx+QQgwldLBbvl/UwWnSefcJs
	senxNVaLy7vmsFm8+f2C3WLp9YtMFi8/nmBxYPdYM28No8fmJfUefVtWMXp83iQXwBLFZZOS
	mpNZllqkb5fAlfHpL0vBDOGK5h1LWRoYr/J3MXJySAiYSGybuIIZwhaTuHBvPVsXIxeHkMBS
	RomFK5eywRRtedYOlZjOKLGm/yqU08YkcXHlFEaQKjYBHYn/+26yg9giAm4S/9YdAitiFuhm
	lPj5exrYKGGBWIlpWz+xgNgsAqoSq57cA2vmFfCQaN52GsjmAFqnIDFnkg1Ir4TAZzaJfd9u
	M0PUC0h8m3yIBaJGVmLTAaizJSUOrrjBMoFRcAEjwypG0dSC5ILipPQiE73ixNzi0rx0veT8
	3E2MwFA9/e/ZhB2M9w5YH2IU4GBU4uF9UDw5RIg1say4MvcQoynQhonMUqLJ+cCIyCuJNzQ2
	M7IwNTE1NjK3NFMS530t9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PXJHN/hn29HaeP
	d25wWqkr8HGv5qKJ5QvPbok+a8TbNF34cEmPUYSOx74ZuzeZdWy18l557+peYa2pu46mZiys
	mH5f1sVUobSnMftYgVqs7eK7zFJt3Ar+yw8c2LkrddHu3s2nNlS+abbNWvakUn3pJlXzwNLU
	3g/+AuVNARrsCnVfdU8wz1BiKc5INNRiLipOBAAOhp+DUAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xoG7HjskhBnM/Wli8X9bDaNF59gmz
	xabH11gtLu+aw2bx5vcLdoul1y8yWbz8eILFgd1jzbw1jB6bl9R79G1ZxejxeZNcAEtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMT39ZCmYIVzTvWMrSwHiVv4uRk0NC
	wERiy7N2NghbTOLCvfVANheHkMB0Rok1/VehnDYmiYsrpzCCVLEJ6Ej833eTHcQWEXCT+Lfu
	EFgRs0A3o8TP39PARgkLxEpM2/qJBcRmEVCVWPXkHlgzr4CHRPO200A2B9A6BYk5k2wmMHIv
	YGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcCc+kdzCuarA4xCjAwajEw9tRODlEiDWx
	rLgy9xCjBAezkgiveSZQiDclsbIqtSg/vqg0J7X4EKMp0PKJzFKiyfnAKM0riTc0NjEzsjQy
	N7QwMjZXEudVsm8LERJITyxJzU5NLUgtgulj4uCUamD03ubX7vajf/EfGZdKzq16YnMOlzHw
	pJhK+vROTNhb0H1Rl+WK5oxS//k8J16928czf2GJ9+czOvXKVaFS/nplu689SM0oPVVYxKha
	HtU98erWf2EnlDZmmcps0Q451a3lt+6DqeqzIzKbD7l7OfT2BrYE1Csvv1JTOMOCf/OVFvtF
	e12+zFRiKc5INNRiLipOBACuqeZYmgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current psci's cpu_suspend callback can be used only when common cpu idle
configuration is enabled. However, it's also needed for system which only
uses generic pm suspend not cpu idle. This patch modifies psci driver to
support both of cases.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 arch/arm64/kernel/psci.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/psci.c b/arch/arm64/kernel/psci.c
index f1dbca7..06d5527 100644
--- a/arch/arm64/kernel/psci.c
+++ b/arch/arm64/kernel/psci.c
@@ -35,6 +35,13 @@
 #define PSCI_POWER_STATE_TYPE_STANDBY		0
 #define PSCI_POWER_STATE_TYPE_POWER_DOWN	1
 
+enum psci_affinity_level {
+	PSCI_AFFINITY_LEVEL_0,
+	PSCI_AFFINITY_LEVEL_1,
+	PSCI_AFFINITY_LEVEL_2,
+	PSCI_AFFINITY_LEVEL_3,
+};
+
 struct psci_power_state {
 	u16	id;
 	u8	type;
@@ -513,27 +520,37 @@ static int psci_suspend_finisher(unsigned long index)
 {
 	struct psci_power_state *state = __this_cpu_read(psci_power_state);
 
+	/* Generic PM suspend without CPUIDLE functionality */
+	if (!state) {
+		struct psci_power_state s = {
+			.affinity_level = PSCI_AFFINITY_LEVEL_3,
+			.type = PSCI_POWER_STATE_TYPE_POWER_DOWN,
+		};
+		return psci_ops.cpu_suspend(s, virt_to_phys(cpu_resume));
+	}
+
 	return psci_ops.cpu_suspend(state[index - 1],
 				    virt_to_phys(cpu_resume));
 }
 
 static int __maybe_unused cpu_psci_cpu_suspend(unsigned long index)
 {
-	int ret;
 	struct psci_power_state *state = __this_cpu_read(psci_power_state);
-	/*
-	 * idle state index 0 corresponds to wfi, should never be called
-	 * from the cpu_suspend operations
-	 */
-	if (WARN_ON_ONCE(!index))
-		return -EINVAL;
 
-	if (state[index - 1].type == PSCI_POWER_STATE_TYPE_STANDBY)
-		ret = psci_ops.cpu_suspend(state[index - 1], 0);
-	else
-		ret = __cpu_suspend(index, psci_suspend_finisher);
+	if (state) {
+		if (WARN_ON_ONCE(!index))
+			return -EINVAL;
+
+		/*
+		 * If idle state initialization is successfully done,
+		 * idle state index 0 corresponds to wfi, should never be
+		 * called from the cpu_suspend operations
+		 */
+		if (state[index - 1].type == PSCI_POWER_STATE_TYPE_STANDBY)
+			return psci_ops.cpu_suspend(state[index - 1], 0);
+	}
 
-	return ret;
+	return __cpu_suspend(index, psci_suspend_finisher);
 }
 
 const struct cpu_operations cpu_psci_ops = {
-- 
1.7.9.5

