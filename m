Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab3EYJM5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 05:12:57 -0400
Received: from mout.gmx.net ([212.227.15.19]:52733 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab3EYJMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 05:12:55 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18r3Yso7TkrBVLKkUSHO1tztg52R2H5PS7zzqBLL8
	A+0yWp9+NCKIzq
From: =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
To: viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: [PATCH] kernel/auditfilter.c: fix compiler warning about decimal constant
Date: Sat, 25 May 2013 11:12:48 +0200
Message-Id: <1369473168-13456-1-git-send-email-toralf.foerster@gmx.de>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixes

  CC      kernel/auditfilter.o
  kernel/auditfilter.c: In function ‘audit_data_to_entry’:
  kernel/auditfilter.c:426:3: warning: this decimal constant is unsigned
  only in ISO C90 [enabled by default]

Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
---
 kernel/auditfilter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 6bd4a90..0ee9eff 100644
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
1.8.1.5

