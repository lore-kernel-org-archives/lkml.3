Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967882Ab3E3H7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:59:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20083 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S967860Ab3E3H7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:59:11 -0400
X-IronPort-AV: E=Sophos;i="4.87,769,1363104000"; 
   d="scan'208";a="7411039"
From: liguang <lig.fnst@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Dave Jones <davej@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Al Viro <viro@zeniv.linux.org.uk>, liguang <lig.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] sys: fix malformed panic massage of reboot
Date: Thu, 30 May 2013 15:58:06 +0800
Message-Id: <1369900686-5936-4-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:57:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:57:34,
	Serialize complete at 2013/05/30 15:57:34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if LINUX_REBOOT_CMD_HALT for reboot failed,
message "cannot halt" will stay in same line
with next message, so append a '\n' for it.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 6dabfc1..c04c611 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -486,7 +486,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 		system_state = SYSTEM_HALT;
 		kernel_halt();
 		do_exit(0);
-		panic("cannot halt");
+		panic("cannot halt.\n");
 
 	case LINUX_REBOOT_CMD_POWER_OFF:
 		system_state = SYSTEM_POWER_OFF;
-- 
1.7.2.5

