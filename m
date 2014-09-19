Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaISAtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 20:49:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaISAtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 20:49:09 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, pmoore@redhat.com, eparis@redhat.com,
        sgrubb@redhat.com
Subject: [PATCH] selinux: services: cleanup orphan keywords in audit log text
Date: Thu, 18 Sep 2014 20:47:48 -0400
Message-Id: <516208b0d38331b8a3318918814e4e321c5117d9.1411086286.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restructure to keyword=value pairs without spaces.  Drop superfluous words in
text.  Make invalid_context a keyword.  Change result= keyword to seresult=.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 security/selinux/ss/services.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 4bca494..e822910 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -728,7 +728,7 @@ static int security_validtrans_handle_fail(struct context *ocontext,
 	if (context_struct_to_string(tcontext, &t, &tlen))
 		goto out;
 	audit_log(current->audit_context, GFP_ATOMIC, AUDIT_SELINUX_ERR,
-		  "security_validate_transition:  denied for"
+		  "op=security_validate_transition seresult=denied"
 		  " oldcontext=%s newcontext=%s taskcontext=%s tclass=%s",
 		  o, n, t, sym_name(&policydb, SYM_CLASSES, tclass-1));
 out:
@@ -877,7 +877,7 @@ int security_bounded_transition(u32 old_sid, u32 new_sid)
 			audit_log(current->audit_context,
 				  GFP_ATOMIC, AUDIT_SELINUX_ERR,
 				  "op=security_bounded_transition "
-				  "result=denied "
+				  "seresult=denied "
 				  "oldcontext=%s newcontext=%s",
 				  old_name, new_name);
 		}
@@ -1351,8 +1351,8 @@ static int compute_sid_handle_invalid_context(
 	if (context_struct_to_string(newcontext, &n, &nlen))
 		goto out;
 	audit_log(current->audit_context, GFP_ATOMIC, AUDIT_SELINUX_ERR,
-		  "security_compute_sid:  invalid context %s"
-		  " for scontext=%s"
+		  "op=security_compute_sid invalid_context=%s"
+		  " scontext=%s"
 		  " tcontext=%s"
 		  " tclass=%s",
 		  n, s, t, sym_name(&policydb, SYM_CLASSES, tclass-1));
@@ -2584,8 +2584,10 @@ int security_sid_mls_copy(u32 sid, u32 mls_sid, u32 *new_sid)
 		rc = convert_context_handle_invalid_context(&newcon);
 		if (rc) {
 			if (!context_struct_to_string(&newcon, &s, &len)) {
-				audit_log(current->audit_context, GFP_ATOMIC, AUDIT_SELINUX_ERR,
-					  "security_sid_mls_copy: invalid context %s", s);
+				audit_log(current->audit_context,
+					  GFP_ATOMIC, AUDIT_SELINUX_ERR,
+					  "op=security_sid_mls_copy "
+					  "invalid_context=%s", s);
 				kfree(s);
 			}
 			goto out_unlock;
-- 
1.7.1

