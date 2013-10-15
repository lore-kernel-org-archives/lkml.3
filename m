Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599Ab3JOUvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:51:00 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:62583 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3JOUu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:50:59 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Liu Chuansheng <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC PATCH 0/3] headers: Consolidate once/cond	style macros
Date: Tue, 15 Oct 2013 22:50:49 +0200
Message-Id: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So here is the patchses I had in some branches for a little while.
Please double check especially the 3rd patch because it removes the
use of .data.unlikely for WARN_ON_ONCE.

I'm not sure this section for the "done" state is something we also want
for printk_once(). What do you think?

Thanks.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	core/once

Thanks,
	Frederic
---

Frederic Weisbecker (3):
      core: New macro to execute code only once
      core: Convert printk_once to use DO_ONCE
      bug: Convert warn macros to use once and cond helpers


 include/asm-generic/bug.h | 57 ++++++++++-------------------------------------
 include/linux/once.h      | 26 +++++++++++++++++++++
 include/linux/printk.h    | 10 ++-------
 3 files changed, 40 insertions(+), 53 deletions(-)
