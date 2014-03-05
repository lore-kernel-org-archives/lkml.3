Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaCEVaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:30:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbaCEV37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:29:59 -0500
Date: Wed, 5 Mar 2014 16:29:55 -0500
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] audit: remove stray newlines from audit_log_lost messages
Message-ID: <20140305212955.GV6301@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling audit_log_lost with a \n in the format string leads to extra
newlines in dmesg.  That function will eventually call audit_panic which
uses pr_err with an explicit \n included.  Just make these calls match the
others that lack \n.

Reported-by: Jonathan Kamens <jik@kamens.brookline.ma.us>
Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

---
 kernel/audit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 34c5a23..f6bce4d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -396,7 +396,7 @@ static void audit_printk_skb(struct sk_buff *skb)
 		if (printk_ratelimit())
 			pr_notice("type=%d %s\n", nlh->nlmsg_type, data);
 		else
-			audit_log_lost("printk limit exceeded\n");
+			audit_log_lost("printk limit exceeded");
 	}
 
 	audit_hold_skb(skb);
@@ -412,7 +412,7 @@ static void kauditd_send_skb(struct sk_buff *skb)
 		BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
 		if (audit_pid) {
 			pr_err("*NO* daemon at audit_pid=%d\n", audit_pid);
-			audit_log_lost("auditd disappeared\n");
+			audit_log_lost("auditd disappeared");
 			audit_pid = 0;
 			audit_sock = NULL;
 		}
-- 
1.8.5.3

