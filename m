Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab3GPETB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 00:19:01 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:41198 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab3GPETA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 00:19:00 -0400
Message-ID: <1373948327.15106.3.camel@ThinkPad-T5421>
Subject: [PATCH] nohz: fix compile warning in tick_nohz_init()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 16 Jul 2013 12:18:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071615-3568-0000-0000-000003EE66F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu is not used after commit 5b8621a68fdcd2baf1d3b413726f913a5254d46a

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 kernel/time/tick-sched.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index e80183f..8145860 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -343,8 +343,6 @@ static int tick_nohz_init_all(void)
 
 void __init tick_nohz_init(void)
 {
-	int cpu;
-
 	if (!have_nohz_full_mask) {
 		if (tick_nohz_init_all() < 0)
 			return;


