Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832Ab3EVURH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:17:07 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:47818 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab3EVURF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:17:05 -0400
From: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "Raphael S. Carvalho" <raphael.scarv@gmail.com>
Subject: [PATCH 1/1] kernel/auditfilter.c: Fixing a warning. GCC warning message: kernel/auditfilter.c:426: warning: this decimal constant is unsigned only in ISO C90
Date: Wed, 22 May 2013 17:14:47 -0300
Message-Id: <1369253687-27636-1-git-send-email-raphael.scarv@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>
---
 kernel/auditfilter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 83a2970..3f3f837 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -423,7 +423,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		f->lsm_rule = NULL;
 
 		/* Support legacy tests for a valid loginuid */
-		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
+		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295U)) {
 			f->type = AUDIT_LOGINUID_SET;
 			f->val = 0;
 		}
-- 
1.7.2.5

