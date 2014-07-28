Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaG1FTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:19:17 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:54100 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaG1FS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:18:57 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: jason.low2@hp.com, davidlohr@hp.com, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -tip/master 7/7] Documentation: Update locking/mutex-design.txt disadvantages
Date: Sun, 27 Jul 2014 22:18:44 -0700
Message-Id: <1406524724-17946-7-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fortunately Jason was able to reduce some of the overhead we
had introduced in the original rwsem optimistic spinning -
an it is now the same size as mutexes. Update the documentation
accordingly.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
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
-- 
1.8.1.4

