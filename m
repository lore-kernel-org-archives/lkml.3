Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbaCCWbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:31:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbaCCWbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:31:40 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com
Cc: Gao feng <gaofeng@cn.fujitsu.com>, eparis@redhat.com, sgrubb@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH] audit: don't generate loginuid log when audit disabled
Date: Mon,  3 Mar 2014 17:30:50 -0500
Message-Id: <4c215d4514933983db3f162c0f6bf6a2a25221e7.1393353030.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gao feng <gaofeng@cn.fujitsu.com>

If audit is disabled, we shouldn't generate loginuid audit
log.

Cc: stable@vger.kernel.org # v3.13-rc1
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
---

Already upstream in 3.14-rc1.  This fixes a bug introduced by:
	da0a6104 audit: loginuid functions coding style


 kernel/auditsc.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index df1e685..9ab02fa 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1971,6 +1971,9 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 	struct audit_buffer *ab;
 	uid_t uid, ologinuid, nloginuid;
 
+	if (!audit_enabled)
+		return;
+
 	uid = from_kuid(&init_user_ns, task_uid(current));
 	ologinuid = from_kuid(&init_user_ns, koldloginuid);
 	nloginuid = from_kuid(&init_user_ns, kloginuid),
-- 
1.7.1

