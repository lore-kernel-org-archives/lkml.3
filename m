Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3CXSXn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 14:23:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab3CXSXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 14:23:41 -0400
Date: Sun, 24 Mar 2013 19:21:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH 3/5] uprobes: Kill the unnecesary filp != NULL check in
	__copy_insn()
Message-ID: <20130324182118.GA13315@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324182040.GA13078@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__copy_insn(filp) can only be called after valid_vma() returns T,
vma->vm_file passed as "filp" can not be NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 0a759c6..e5d479f 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -478,9 +478,6 @@ __copy_insn(struct address_space *mapping, struct file *filp, char *insn,
 {
 	struct page *page;
 
-	if (!filp)
-		return -EINVAL;
-
 	if (!mapping->a_ops->readpage)
 		return -EIO;
 	/*
-- 
1.5.5.1

