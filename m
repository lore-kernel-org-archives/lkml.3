Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932974AbaEEXMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:12:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57876 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666AbaEEXMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:12:41 -0400
Date: Mon, 5 May 2014 16:12:31 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-3adc1beacdbc1d6c4be99ecc2f87eac1c1e6f857@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1398984278-29319-2-git-send-email-andi@firstfloor.org>
References: <1398984278-29319-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] asmlinkage: Revert "lto:
  Make asmlinkage __visible"
Git-Commit-ID: 3adc1beacdbc1d6c4be99ecc2f87eac1c1e6f857
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

Commit-ID:  3adc1beacdbc1d6c4be99ecc2f87eac1c1e6f857
Gitweb:     http://git.kernel.org/tip/3adc1beacdbc1d6c4be99ecc2f87eac1c1e6f857
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 2 May 2014 00:44:36 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 5 May 2014 16:07:37 -0700

asmlinkage: Revert "lto: Make asmlinkage __visible"

As requested by Linus, revert adding __visible to asmlinkage.
Instead we add __visible explicitely to all the symbols
that need it.

This reverts commit 128ea04a9885af9629059e631ddf0cab4815b589.

Link: http://lkml.kernel.org/r/1398984278-29319-2-git-send-email-andi@firstfloor.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/linkage.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 34a513a..a6a42dd 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -12,9 +12,9 @@
 #endif
 
 #ifdef __cplusplus
-#define CPP_ASMLINKAGE extern "C" __visible
+#define CPP_ASMLINKAGE extern "C"
 #else
-#define CPP_ASMLINKAGE __visible
+#define CPP_ASMLINKAGE
 #endif
 
 #ifndef asmlinkage
