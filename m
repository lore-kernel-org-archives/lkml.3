Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3COQwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:52:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41279 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab3COQv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:51:59 -0400
X-IronPort-AV: E=Sophos;i="4.84,852,1355068800"; 
   d="scan'208";a="6880050"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 5/9] tomoyo: use DEFINE_SRCU() to define tomoyo_ss
Date: Sat, 16 Mar 2013 00:50:53 +0800
Message-Id: <1363366257-4886-6-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
References: <1363366257-4886-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:50:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/16 00:50:39,
	Serialize complete at 2013/03/16 00:50:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEFINE_STATIC_SRCU() defines srcu struct and do init at build time.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 security/tomoyo/tomoyo.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index a2ee362..f0b756e 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -536,7 +536,7 @@ static struct security_operations tomoyo_security_ops = {
 };
 
 /* Lock for GC. */
-struct srcu_struct tomoyo_ss;
+DEFINE_SRCU(tomoyo_ss);
 
 /**
  * tomoyo_init - Register TOMOYO Linux as a LSM module.
@@ -550,8 +550,7 @@ static int __init tomoyo_init(void)
 	if (!security_module_enable(&tomoyo_security_ops))
 		return 0;
 	/* register ourselves with the security framework */
-	if (register_security(&tomoyo_security_ops) ||
-	    init_srcu_struct(&tomoyo_ss))
+	if (register_security(&tomoyo_security_ops))
 		panic("Failure registering TOMOYO Linux");
 	printk(KERN_INFO "TOMOYO Linux initialized\n");
 	cred->security = &tomoyo_kernel_domain;
-- 
1.7.4.4

