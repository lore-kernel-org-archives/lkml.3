Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967872Ab3E3H7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:59:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S967857Ab3E3H7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:59:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,769,1363104000"; 
   d="scan'208";a="7411038"
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
Subject: [PATCH 3/4] sys/reboot: boolize C_A_D
Date: Thu, 30 May 2013 15:58:05 +0800
Message-Id: <1369900686-5936-3-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1369900686-5936-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:57:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:57:32,
	Serialize complete at 2013/05/30 15:57:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 include/linux/reboot.h |    2 +-
 kernel/sys.c           |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 23b3630..a8c5e4c 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -35,7 +35,7 @@ extern void kernel_restart(char *cmd);
 extern void kernel_halt(void);
 extern void kernel_power_off(void);
 
-extern int C_A_D; /* for sysctl */
+extern bool C_A_D; /* for sysctl */
 void ctrl_alt_del(void);
 
 #define POWEROFF_CMD_PATH_LEN	256
diff --git a/kernel/sys.c b/kernel/sys.c
index 7f56ed4..6dabfc1 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -119,7 +119,7 @@ EXPORT_SYMBOL(fs_overflowgid);
  * this indicates whether you can reboot with ctrl-alt-del: the default is yes
  */
 
-int C_A_D = 1;
+bool C_A_D = true;
 struct pid *cad_pid;
 EXPORT_SYMBOL(cad_pid);
 
@@ -475,11 +475,11 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 		break;
 
 	case LINUX_REBOOT_CMD_CAD_ON:
-		C_A_D = 1;
+		C_A_D = true;
 		break;
 
 	case LINUX_REBOOT_CMD_CAD_OFF:
-		C_A_D = 0;
+		C_A_D = false;
 		break;
 
 	case LINUX_REBOOT_CMD_HALT:
-- 
1.7.2.5

