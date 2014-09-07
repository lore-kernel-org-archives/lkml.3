Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaIGJtL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 05:49:11 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:53296 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaIGJtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 05:49:08 -0400
From: Mostyn Bramley-Moore <mbmcode@gmail.com>
To: Oleg Drokin <oleg.drokin@intel.com>, mbmcode@gmail.com
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2] staging/lustre: annotate lock/unlock in lov_stripe_lock / lov_stripe_unlock
Date: Sun,  7 Sep 2014 11:46:40 +0200
Message-Id: <1410083200-3114-1-git-send-email-mbmcode@gmail.com>
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

