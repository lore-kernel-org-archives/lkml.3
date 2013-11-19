Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3KSQYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:24:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab3KSQYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:24:37 -0500
Date: Tue, 19 Nov 2013 17:25:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] uprobes: Document xol_area and arch_uprobe->insn/ixol
Message-ID: <20131119162545.GA776@redhat.com>
References: <20131109190344.GA32281@redhat.com> <20131111084149.GC12405@gmail.com> <20131111195836.GA20615@redhat.com> <20131111210327.GG18886@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111210327.GG18886@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 11/11, Ingo Molnar wrote:
> > >
> > > You guys are changing code that reads like gobbledygook to people
> > > reading it for the first time.
> >
> > Not that I am trying to defense uprobes, but this is equally true for
> > any piece of kernel code, at least to me ;)
>
> I'm really not suggesting to do overly much - only for some minimal blurb
> like the scheduler has in most places:

OK. Let me try to make a first step to improve this a little bit...

How about the patch below? Srikar?


Subject: [PATCH] uprobes: Document xol_area and arch_uprobe->insn/ixol

Document xol_area and arch_uprobe.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 51a7f53..b886a5e 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -73,6 +73,17 @@ struct uprobe {
 	struct inode		*inode;		/* Also hold a ref to inode */
 	loff_t			offset;
 	unsigned long		flags;
+
+	/*
+	 * The generic code assumes that it has two members of unknown type
+	 * owned by the arch-specific code:
+	 *
+	 * 	insn -	copy_insn() saves the original instruction here for
+	 *		arch_uprobe_analyze_insn().
+	 *
+	 *	ixol -	potentially modified instruction to execute out of
+	 *		line, copied to xol_area by xol_get_insn_slot().
+	 */
 	struct arch_uprobe	arch;
 };
 
@@ -86,6 +97,10 @@ struct return_instance {
 };
 
 /*
+ * Execute out of line area: anonymous executable mapping installed
+ * by the probed task to execute the copy of the original instruction
+ * mangled by set_swbp().
+ *
  * On a breakpoint hit, thread contests for a slot.  It frees the
  * slot after singlestep. Currently a fixed number of slots are
  * allocated.
-- 
1.5.5.1


