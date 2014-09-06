Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaIFKUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 06:20:20 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39577 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaIFKUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 06:20:15 -0400
From: Mostyn Bramley-Moore <mbmcode@gmail.com>
To: linux-kernel@vger.kernel.org, mbmcode@gmail.com
Subject: [PATCH] staging/lustre: annotate lock/unlock in lov_stripe_lock / lov_stripe_unlock
Date: Sat,  6 Sep 2014 12:20:06 +0200
Message-Id: <1409998806-6413-1-git-send-email-mbmcode@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Annotate the lock/unlock pair in lov_stripe_lock/lov_stripe_unlock to
avoid sparse warning about a context imbalance.
Part of the eudyptula challenge: http://eudyptula-challenge.org/

Signed-off-by: Mostyn Bramley-Moore <mbmcode@gmail.com>
---
 drivers/staging/lustre/lustre/lov/lov_obd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index cb778df..0baef6a 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -2649,6 +2649,7 @@ static int lov_extent_calc(struct obd_export *exp, struct lov_stripe_md *lsm,
 }
 
 void lov_stripe_lock(struct lov_stripe_md *md)
+		__acquires(&md->lsm_lock)
 {
 	LASSERT(md->lsm_lock_owner != current_pid());
 	spin_lock(&md->lsm_lock);
@@ -2658,6 +2659,7 @@ void lov_stripe_lock(struct lov_stripe_md *md)
 EXPORT_SYMBOL(lov_stripe_lock);
 
 void lov_stripe_unlock(struct lov_stripe_md *md)
+		__releases(&md->lsm_lock)
 {
 	LASSERT(md->lsm_lock_owner == current_pid());
 	md->lsm_lock_owner = 0;
-- 
1.9.1

