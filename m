Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaKRBDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:03:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49386 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaKRBDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:03:45 -0500
Date: Mon, 17 Nov 2014 17:03:29 -0800
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-abe1e395f6171cb2d07330c690fe0285f7f859e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        dave@sr71.net, mingo@kernel.org, dave.hansen@linux.intel.com
Reply-To: dave.hansen@linux.intel.com, mingo@kernel.org, dave@sr71.net,
        tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20141118003608.837015B3@viggo.jf.intel.com>
References: <20141118003608.837015B3@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mpx] fs: Do not include mpx.h in exec.c
Git-Commit-ID: abe1e395f6171cb2d07330c690fe0285f7f859e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  abe1e395f6171cb2d07330c690fe0285f7f859e6
Gitweb:     http://git.kernel.org/tip/abe1e395f6171cb2d07330c690fe0285f7f859e6
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Mon, 17 Nov 2014 16:36:08 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 18 Nov 2014 02:01:40 +0100

fs: Do not include mpx.h in exec.c

We no longer need mpx.h in exec.c.  This will obviously also
break the build for non-x86 builds.  We get the MPX includes that
we need from mmu_context.h now.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>
Link: http://lkml.kernel.org/r/20141118003608.837015B3@viggo.jf.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/exec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 65d4f5c..01aebe3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -60,7 +60,6 @@
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
-#include <asm/mpx.h>
 
 #include <trace/events/task.h>
 #include "internal.h"
