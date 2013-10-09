Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab3JIMIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:08:20 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:35842 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab3JIMIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:08:17 -0400
Date: Wed, 9 Oct 2013 14:08:09 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [PATCH] UPROBES: Remove useless __weak attribute
Message-ID: <20131009120809.GN1615@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<linux/uprobes.h> declares arch_uprobe_skip_sstep() as a weak function.
But as there is no definition of generic version so when trying to build
uprobes for an architecture that doesn't yet have a arch_uprobe_skip_sstep()
implementation, the vmlinux will try to call arch_uprobe_skip_sstep()
somehwere in Stupidhistan leading to a system crash.  We rather want a
proper link error so remove arch_uprobe_skip_sstep().

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 include/linux/uprobes.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 2a9d75d..cec7397 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -124,7 +124,7 @@ extern int uprobe_post_sstep_notifier(struct pt_regs *regs);
 extern int uprobe_pre_sstep_notifier(struct pt_regs *regs);
 extern void uprobe_notify_resume(struct pt_regs *regs);
 extern bool uprobe_deny_signal(void);
-extern bool __weak arch_uprobe_skip_sstep(struct arch_uprobe *aup, struct pt_regs *regs);
+extern bool arch_uprobe_skip_sstep(struct arch_uprobe *aup, struct pt_regs *regs);
 extern void uprobe_clear_state(struct mm_struct *mm);
 #else /* !CONFIG_UPROBES */
 struct uprobes_state {
