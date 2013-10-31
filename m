Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3JaPhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:37:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab3JaPhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:37:48 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <onestero@redhat.com>, Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/4][v2] audit: remove unused envc member of audit_aux_data_execve
Date: Thu, 31 Oct 2013 11:37:10 -0400
Message-Id: <a6f04a33d868bf862456da9465895e97fe5544b8.1383233534.git.rgb@redhat.com>
In-Reply-To: <cover.1383233533.git.rgb@redhat.com>
References: <cover.1383233533.git.rgb@redhat.com>
In-Reply-To: <cover.1383233533.git.rgb@redhat.com>
References: <cover.1383233533.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of write-only audit_aux_data_exeve structure member envc.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditsc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 24047f4..c9abaa0 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -98,7 +98,6 @@ struct audit_aux_data {
 struct audit_aux_data_execve {
 	struct audit_aux_data	d;
 	int argc;
-	int envc;
 	struct mm_struct *mm;
 };
 
@@ -2132,7 +2131,6 @@ int __audit_bprm(struct linux_binprm *bprm)
 		return -ENOMEM;
 
 	ax->argc = bprm->argc;
-	ax->envc = bprm->envc;
 	ax->mm = bprm->mm;
 	ax->d.type = AUDIT_EXECVE;
 	ax->d.next = context->aux;
-- 
1.7.1

