Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab3BIBI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:08:56 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:34330 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947640Ab3BIBIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:52 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 14/16] intel_idle: remove use and definition of MWAIT_MAX_NUM_CSTATES
Date: Fri,  8 Feb 2013 20:08:18 -0500
Message-Id: <137ecc779c80138723677209730738d76262e810.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Cosmetic only.

Replace use of MWAIT_MAX_NUM_CSTATES with CPUIDLE_STATE_MAX.
They are both 8, so this patch has no functional change.

The reason to change is that intel_idle will soon be able
to export more than the 8 "major" states supported by MWAIT.
When we hit that limit, it is important to know
where the limit comes from.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/mwait.h |  1 -
 drivers/idle/intel_idle.c    | 16 ++++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
index bcdff99..3f44732 100644
--- a/arch/x86/include/asm/mwait.h
+++ b/arch/x86/include/asm/mwait.h
@@ -4,7 +4,6 @@
 #define MWAIT_SUBSTATE_MASK		0xf
 #define MWAIT_CSTATE_MASK		0xf
 #define MWAIT_SUBSTATE_SIZE		4
-#define MWAIT_MAX_NUM_CSTATES		8
 
 #define CPUID_MWAIT_LEAF		5
 #define CPUID5_ECX_EXTENSIONS_SUPPORTED 0x1
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index fa71477..c949a6f 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -74,7 +74,7 @@ static struct cpuidle_driver intel_idle_driver = {
 	.en_core_tk_irqen = 1,
 };
 /* intel_idle.max_cstate=0 disables driver */
-static int max_cstate = MWAIT_MAX_NUM_CSTATES - 1;
+static int max_cstate = CPUIDLE_STATE_MAX - 1;
 
 static unsigned int mwait_substates;
 
@@ -123,7 +123,7 @@ static struct cpuidle_state *cpuidle_state_table;
  * which is also the index into the MWAIT hint array.
  * Thus C0 is a dummy.
  */
-static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
+static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
 		.name = "C1-NHM",
@@ -148,7 +148,7 @@ static struct cpuidle_state nehalem_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = &intel_idle },
 };
 
-static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
+static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
 		.name = "C1-SNB",
@@ -180,7 +180,7 @@ static struct cpuidle_state snb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = &intel_idle },
 };
 
-static struct cpuidle_state ivb_cstates[MWAIT_MAX_NUM_CSTATES] = {
+static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
 		.name = "C1-IVB",
@@ -212,7 +212,7 @@ static struct cpuidle_state ivb_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = &intel_idle },
 };
 
-static struct cpuidle_state hsw_cstates[MWAIT_MAX_NUM_CSTATES] = {
+static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
 		.name = "C1-HSW",
@@ -244,7 +244,7 @@ static struct cpuidle_state hsw_cstates[MWAIT_MAX_NUM_CSTATES] = {
 		.enter = &intel_idle },
 };
 
-static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
+static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
 		.name = "C1-ATM",
@@ -503,7 +503,7 @@ static int intel_idle_cpuidle_driver_init(void)
 
 	drv->state_count = 1;
 
-	for (cstate = 1; cstate < MWAIT_MAX_NUM_CSTATES; ++cstate) {
+	for (cstate = 1; cstate < CPUIDLE_STATE_MAX; ++cstate) {
 		int num_substates;
 
 		if (cstate > max_cstate) {
@@ -560,7 +560,7 @@ static int intel_idle_cpu_init(int cpu)
 
 	dev->state_count = 1;
 
-	for (cstate = 1; cstate < MWAIT_MAX_NUM_CSTATES; ++cstate) {
+	for (cstate = 1; cstate < CPUIDLE_STATE_MAX; ++cstate) {
 		int num_substates;
 
 		if (cstate > max_cstate) {
-- 
1.8.1.3.535.ga923c31

