Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaHMK5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:57:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaHMK5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:57:21 -0400
Date: Wed, 13 Aug 2014 03:56:26 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-0a7cbf9abe3198461de3d3e97268db32a646ba06@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, jason.low2@hp.com, tglx@linutronix.de,
        davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, jason.low2@hp.com, tglx@linutronix.de,
        davidlohr@hp.com
In-Reply-To: <1406752916-3341-7-git-send-email-davidlohr@hp.com>
References: <1406752916-3341-7-git-send-email-davidlohr@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/Documentation: Update locking/
 mutex-design.txt disadvantages
Git-Commit-ID: 0a7cbf9abe3198461de3d3e97268db32a646ba06
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

Commit-ID:  0a7cbf9abe3198461de3d3e97268db32a646ba06
Gitweb:     http://git.kernel.org/tip/0a7cbf9abe3198461de3d3e97268db32a646ba06
Author:     Davidlohr Bueso <davidlohr@hp.com>
AuthorDate: Wed, 30 Jul 2014 13:41:56 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 10:32:04 +0200

locking/Documentation: Update locking/mutex-design.txt disadvantages

Fortunately Jason was able to reduce some of the overhead we
had introduced in the original rwsem optimistic spinning -
an it is now the same size as mutexes. Update the documentation
accordingly.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: aswin@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Link: http://lkml.kernel.org/r/1406752916-3341-7-git-send-email-davidlohr@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/locking/mutex-design.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/locking/mutex-design.txt b/Documentation/locking/mutex-design.txt
index ee231ed..60c482d 100644
--- a/Documentation/locking/mutex-design.txt
+++ b/Documentation/locking/mutex-design.txt
@@ -145,9 +145,9 @@ Disadvantages
 
 Unlike its original design and purpose, 'struct mutex' is larger than
 most locks in the kernel. E.g: on x86-64 it is 40 bytes, almost twice
-as large as 'struct semaphore' (24 bytes) and 8 bytes shy of the
-'struct rw_semaphore' variant. Larger structure sizes mean more CPU
-cache and memory footprint.
+as large as 'struct semaphore' (24 bytes) and tied, along with rwsems,
+for the largest lock in the kernel. Larger structure sizes mean more
+CPU cache and memory footprint.
 
 When to use mutexes
 -------------------
