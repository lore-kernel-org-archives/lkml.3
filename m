Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab3LJXD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 18:03:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53723 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3LJXDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 18:03:50 -0500
Date: Tue, 10 Dec 2013 15:03:38 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-0mbwou1zt7pafij09b897lg3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        stable@vger.kernel.org, kevin.b.smith@intel.com,
        sunil.k.pandey@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kevin.b.smith@intel.com,
        sunil.k.pandey@intel.com, tglx@linutronix.de, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, build, icc: Remove uninitialized_var()
  from compiler-intel.h
Git-Commit-ID: 503cf95c061a0551eb684da364509297efbe55d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 15:03:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  503cf95c061a0551eb684da364509297efbe55d9
Gitweb:     http://git.kernel.org/tip/503cf95c061a0551eb684da364509297efbe55d9
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 10 Dec 2013 14:56:06 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 10 Dec 2013 15:01:01 -0800

x86, build, icc: Remove uninitialized_var() from compiler-intel.h

When compiling with icc, <linux/compiler-gcc.h> ends up included
because the icc environment defines __GNUC__.  Thus, we neither need
nor want to have this macro defined in both compiler-gcc.h and
compiler-intel.h, and the fact that they are inconsistent just makes
the compiler spew warnings.

Reported-by: Sunil K. Pandey <sunil.k.pandey@intel.com>
Cc: Kevin B. Smith <kevin.b.smith@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-0mbwou1zt7pafij09b897lg3@git.kernel.org
Cc: <stable@vger.kernel.org>
---
 include/linux/compiler-intel.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/compiler-intel.h b/include/linux/compiler-intel.h
index 973ce10..dc1bd3d 100644
--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -28,8 +28,6 @@
 
 #endif
 
-#define uninitialized_var(x) x
-
 #ifndef __HAVE_BUILTIN_BSWAP16__
 /* icc has this, but it's called _bswap16 */
 #define __HAVE_BUILTIN_BSWAP16__
