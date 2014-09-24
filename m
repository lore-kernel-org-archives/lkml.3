Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaIXNuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:50:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38842 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbaIXNuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:50:16 -0400
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>, Pranith Kumar <bobby.prani@gmail.com>,
        Christoph Lameter <cl@linux.com>, Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] Docs: this_cpu_ops: remove redundant add forms
Date: Wed, 24 Sep 2014 14:49:43 +0100
Message-Id: <1411566583-22220-1-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I spotted the below while trying to figure out how to use this_cpu ops,
and it left me confused for a short while.

I guess that this is a refactoring fallout rather than there being a
special this_cpu_add variant?

Mark.

---->8----
Commit ac490f4dca94 (Documentation: this_cpu_ops.txt: Update description
of this_cpu_ops) added lists of {__,}this_cpu operations, but these have
duplicate, parameter-less entries for {__,}this_cpu_add which don't
correspond to any implementation. No other operations have such
duplicate entries.

Given both are also listed with their full complement of arguments, the
empty forms are redundant and can be removed. This patch performs said
removal.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
 Documentation/this_cpu_ops.txt | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/this_cpu_ops.txt b/Documentation/this_cpu_ops.txt
index 0ec9957..2cbf719 100644
--- a/Documentation/this_cpu_ops.txt
+++ b/Documentation/this_cpu_ops.txt
@@ -41,7 +41,6 @@ The following this_cpu() operations with implied preemption protection
 are defined. These operations can be used without worrying about
 preemption and interrupts.
 
-	this_cpu_add()
 	this_cpu_read(pcp)
 	this_cpu_write(pcp, val)
 	this_cpu_add(pcp, val)
@@ -225,7 +224,6 @@ still occur while an operation is in progress and if the interrupt too
 modifies the variable, then RMW actions can not be guaranteed to be
 safe.
 
-	__this_cpu_add()
 	__this_cpu_read(pcp)
 	__this_cpu_write(pcp, val)
 	__this_cpu_add(pcp, val)
-- 
1.9.1

