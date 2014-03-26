Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbaCZVhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 17:37:51 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:51194 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756193AbaCZVfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 17:35:10 -0400
X-IronPort-AV: E=Sophos;i="4.97,737,1389740400"; 
   d="scan'208";a="64902686"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: kernel-janitors@vger.kernel.org, tglx@linutronix.de,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] MIPS: Lasat: replace del_timer by del_timer_sync
Date: Wed, 26 Mar 2014 22:33:43 +0100
Message-Id: <1395869625-15209-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1395869625-15209-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use del_timer_sync to ensure that the timer is stopped on all CPUs before
the driver exists.

This change was suggested by Thomas Gleixner

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
declarer name module_exit;
identifier ex;
@@

module_exit(ex);

@@
identifier r.ex;
@@

ex(...) {
  <...
- del_timer
+ del_timer_sync
    (...)
  ...>
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 arch/mips/lasat/picvue_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/lasat/picvue_proc.c b/arch/mips/lasat/picvue_proc.c
index 638c5db..2bcd839 100644
--- a/arch/mips/lasat/picvue_proc.c
+++ b/arch/mips/lasat/picvue_proc.c
@@ -175,7 +175,7 @@ static void pvc_proc_cleanup(void)
 	remove_proc_entry("scroll", pvc_display_dir);
 	remove_proc_entry(DISPLAY_DIR_NAME, NULL);
 
-	del_timer(&timer);
+	del_timer_sync(&timer);
 }
 
 static int __init pvc_proc_init(void)

