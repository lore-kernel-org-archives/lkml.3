Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaJCCHn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 22:07:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbaJCCFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 22:05:52 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com
Subject: [PATCH 1/7] audit: put rule existence check in canonical order
Date: Thu,  2 Oct 2014 22:05:18 -0400
Message-Id: <2e938b9c3cde9025fbdef8f1d267719205eae814.1412285491.git.rgb@redhat.com>
In-Reply-To: <cover.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
In-Reply-To: <cover.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use same rule existence check order as audit_make_tree(), audit_to_watch(),
update_lsm_rule() for legibility.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditfilter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 40ed981..4a11697 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -163,7 +163,7 @@ static inline int audit_to_inode(struct audit_krule *krule,
 				 struct audit_field *f)
 {
 	if (krule->listnr != AUDIT_FILTER_EXIT ||
-	    krule->watch || krule->inode_f || krule->tree ||
+	    krule->inode_f || krule->watch || krule->tree ||
 	    (f->op != Audit_equal && f->op != Audit_not_equal))
 		return -EINVAL;
 
-- 
1.7.1

