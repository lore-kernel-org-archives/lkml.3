Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3K3NnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 08:43:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60179 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3K3NnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 08:43:03 -0500
Date: Sat, 30 Nov 2013 05:42:50 -0800
From: tip-bot for Henrik Austad <tipbot@zytor.com>
Message-ID: <tip-854ff82ab085aed7509f6fb90f79ce6c41ee1fa4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        henrik@austad.us, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        henrik@austad.us, tglx@linutronix.de
In-Reply-To: <1385590680-8110-1-git-send-email-henrik@austad.us>
References: <1385590680-8110-1-git-send-email-henrik@austad.us>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] Documentation/robust-futex-API:
  Count properly to 4
Git-Commit-ID: 854ff82ab085aed7509f6fb90f79ce6c41ee1fa4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 05:42:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  854ff82ab085aed7509f6fb90f79ce6c41ee1fa4
Gitweb:     http://git.kernel.org/tip/854ff82ab085aed7509f6fb90f79ce6c41ee1fa4
Author:     Henrik Austad <henrik@austad.us>
AuthorDate: Wed, 27 Nov 2013 23:18:00 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 30 Nov 2013 14:08:28 +0100

Documentation/robust-futex-API: Count properly to 4

A strictly monotonically increasing sequence is normally used in
numbered lists as they provide an intuitive ordering of the
elements.

However, in situations where race conditions can appear, this
assumption breaks down and you can end up with unpredictable
results, leading to a rather confusing list :-)

This changes the numbered list 1,2,2,2 to the more intuitive
1,2,3,4.

Introduced in:

  2eec9ad91f71 [PATCH] lightweight robust futexes: docs

Signed-off-by: Henrik Austad <henrik@austad.us>
Link: http://lkml.kernel.org/r/1385590680-8110-1-git-send-email-henrik@austad.us
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/robust-futex-ABI.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/robust-futex-ABI.txt b/Documentation/robust-futex-ABI.txt
index fd1cd8a..16eb314f 100644
--- a/Documentation/robust-futex-ABI.txt
+++ b/Documentation/robust-futex-ABI.txt
@@ -146,8 +146,8 @@ On removal:
  1) set the 'list_op_pending' word to the address of the 'lock entry'
     to be removed,
  2) remove the lock entry for this lock from the 'head' list,
- 2) release the futex lock, and
- 2) clear the 'lock_op_pending' word.
+ 3) release the futex lock, and
+ 4) clear the 'lock_op_pending' word.
 
 On exit, the kernel will consider the address stored in
 'list_op_pending' and the address of each 'lock word' found by walking
