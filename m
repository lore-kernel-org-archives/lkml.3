Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbbAELe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:34:26 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:16976 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAELeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:34:24 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <masami.hiramatsu.pt@hitachi.com>, <tixy@linaro.org>,
        <linux@arm.linux.org.uk>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v19 02/11] ARM: kprobes: remove unused ARM decoder actions.
Date: Mon, 5 Jan 2015 19:29:14 +0800
Message-ID: <1420457354-77099-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1420457284-76923-1-git-send-email-wangnan0@huawei.com>
References: <1420457284-76923-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3 actions which is never used:

 PROBES_MOV_HALFWORD,
 PROBES_SEV,
 PROBES_WFE,

This patch removes them.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/probes/decode-arm.h          | 3 ---
 arch/arm/probes/kprobes/actions-arm.c | 3 ---
 arch/arm/probes/uprobes/actions-arm.c | 3 ---
 3 files changed, 9 deletions(-)

diff --git a/arch/arm/probes/decode-arm.h b/arch/arm/probes/decode-arm.h
index 9c56b40..f0dbc5a 100644
--- a/arch/arm/probes/decode-arm.h
+++ b/arch/arm/probes/decode-arm.h
@@ -38,9 +38,6 @@ enum probes_arm_action {
 	PROBES_MOV_IP_SP,
 	PROBES_DATA_PROCESSING_REG,
 	PROBES_DATA_PROCESSING_IMM,
-	PROBES_MOV_HALFWORD,
-	PROBES_SEV,
-	PROBES_WFE,
 	PROBES_SATURATE,
 	PROBES_REV,
 	PROBES_MMI,
diff --git a/arch/arm/probes/kprobes/actions-arm.c b/arch/arm/probes/kprobes/actions-arm.c
index 8797879..099aeb0 100644
--- a/arch/arm/probes/kprobes/actions-arm.c
+++ b/arch/arm/probes/kprobes/actions-arm.c
@@ -325,9 +325,6 @@ const union decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
 		.handler = emulate_rd12rn16rm0rs8_rwflags},
 	[PROBES_DATA_PROCESSING_IMM] = {
 		.handler = emulate_rd12rn16rm0rs8_rwflags},
-	[PROBES_MOV_HALFWORD] = {.handler = emulate_rd12rm0_noflags_nopc},
-	[PROBES_SEV] = {.handler = probes_emulate_none},
-	[PROBES_WFE] = {.handler = probes_simulate_nop},
 	[PROBES_SATURATE] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
 	[PROBES_REV] = {.handler = emulate_rd12rm0_noflags_nopc},
 	[PROBES_MMI] = {.handler = emulate_rd12rn16rm0_rwflags_nopc},
diff --git a/arch/arm/probes/uprobes/actions-arm.c b/arch/arm/probes/uprobes/actions-arm.c
index 1dd4916..6a271d6 100644
--- a/arch/arm/probes/uprobes/actions-arm.c
+++ b/arch/arm/probes/uprobes/actions-arm.c
@@ -217,9 +217,6 @@ const union decode_action uprobes_probes_actions[] = {
 		.decoder = decode_rd12rn16rm0rs8_rwflags},
 	[PROBES_DATA_PROCESSING_IMM] = {
 		.decoder = decode_rd12rn16rm0rs8_rwflags},
-	[PROBES_MOV_HALFWORD] = {.handler = probes_simulate_nop},
-	[PROBES_SEV] = {.handler = probes_simulate_nop},
-	[PROBES_WFE] = {.handler = probes_simulate_nop},
 	[PROBES_SATURATE] = {.handler = probes_simulate_nop},
 	[PROBES_REV] = {.handler = probes_simulate_nop},
 	[PROBES_MMI] = {.handler = probes_simulate_nop},
-- 
1.8.4

