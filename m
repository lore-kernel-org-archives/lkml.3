Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab3H3KZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:25:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13037 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab3H3KZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:25:29 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-2b-52207311e539
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Len Brown <lenb@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] intel_idle: shrink states tables
Date: Fri, 30 Aug 2013 12:25:10 +0200
Message-id: <2945985.mxvmQoz8DY@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jQV3BYoUgg+YuU4t5n2Utdj58y2Zx
	edccNovPvUcYLfoX9jI5sHpsWtXJ5nHn2h42j0eLWxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MqY
	/aK44KBIxZXvP1kbGFcJdDFyckgImEgcXL+OHcIWk7hwbz0biC0kMJ1R4mu7XhcjF5DdwiRx
	9816ZpAEm4CVxMT2VYwgtoiAvMSmnZ0sIEXMAr2MEkdnXQYrEhYwlVh37QILiM0ioCqxaOor
	VhCbV0BTYsbnQ2BxUQFPiU+TljJDxAUlfky+BxZnBhq6b/9UVghbS2L9zuNMExj5ZiEpm4Wk
	bBaSsgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgoPymdQOxpUNFocYBTgYlXh4HwTL
	BwmxJpYVV+YeYpTgYFYS4a1IVQgS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1
	OzW1ILUIJsvEwSnVwJhdm85/XqO2TniOwf8dswV+vNF9/9dmhubqfg7+N539jIKz1+56wbdF
	+4L4XnmNir1/uQxXVH8+dz39nnNQ0Lw9LJ+eam69uGyT+cq7vBcOZ5xd3PQ5WOFF0H2GFZ53
	p4vO6G6c/6PKgKeAofHbHJ9lfH/4+1wz5UV37yqZml+/o8bmSNOTrjdKLMUZiYZazEXFiQC6
	hPpTRgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to define CPUIDLE_STATE_MAX (currently 10) entries
in states tables if the driver always stops iterating over table when
it encounters first .enter == NULL entry.

$ size drivers/idle/intel_idle.o.*
   text    data     bss     dec     hex filename
   2886    5440      32    8358    20a6 drivers/idle/intel_idle.o.before
   2886    3752      32    6670    1a0e drivers/idle/intel_idle.o.after

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/idle/intel_idle.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index fa6964d..9c97fbb42 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -123,7 +123,7 @@ static struct cpuidle_state *cpuidle_state_table;
  * which is also the index into the MWAIT hint array.
  * Thus C0 is a dummy.
  */
-static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state nehalem_cstates[] = {
 	{
 		.name = "C1-NHM",
 		.desc = "MWAIT 0x00",
@@ -156,7 +156,7 @@ static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state snb_cstates[] = {
 	{
 		.name = "C1-SNB",
 		.desc = "MWAIT 0x00",
@@ -196,7 +196,7 @@ static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state ivb_cstates[] = {
 	{
 		.name = "C1-IVB",
 		.desc = "MWAIT 0x00",
@@ -236,7 +236,7 @@ static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state hsw_cstates[] = {
 	{
 		.name = "C1-HSW",
 		.desc = "MWAIT 0x00",
@@ -297,7 +297,7 @@ static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
 		.enter = NULL }
 };
 
-static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state atom_cstates[] = {
 	{
 		.name = "C1E-ATM",
 		.desc = "MWAIT 0x00",
@@ -628,7 +628,7 @@ static int intel_idle_cpu_init(int cpu)
 		int num_substates, mwait_hint, mwait_cstate, mwait_substate;
 
 		if (cpuidle_state_table[cstate].enter == NULL)
-			continue;
+			break;
 
 		if (cstate + 1 > max_cstate) {
 			printk(PREFIX "max_cstate %d reached\n", max_cstate);
-- 
1.8.2.3


