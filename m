Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966994AbaCUAxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:53:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965565AbaCUAEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 3.13 140/149] audit: dont generate loginuid log when audit disabled
Date: Thu, 20 Mar 2014 17:05:03 -0700
Message-Id: <20140321000441.808617210@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao feng <gaofeng@cn.fujitsu.com>

commit c2412d91c68426e22add16550f97ae5cd988a159 upstream.

If audit is disabled, we shouldn't generate loginuid audit
log.

Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/auditsc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1971,6 +1971,9 @@ static void audit_log_set_loginuid(kuid_
 	struct audit_buffer *ab;
 	uid_t uid, ologinuid, nloginuid;
 
+	if (!audit_enabled)
+		return;
+
 	uid = from_kuid(&init_user_ns, task_uid(current));
 	ologinuid = from_kuid(&init_user_ns, koldloginuid);
 	nloginuid = from_kuid(&init_user_ns, kloginuid),


