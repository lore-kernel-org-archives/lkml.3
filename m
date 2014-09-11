Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaIKIyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:54:15 -0400
Received: from mga14.intel.com ([192.55.52.115]:30409 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995AbaIKIyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:54:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="589733193"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v8 06/10] mips: sync struct siginfo with general version
Date: Thu, 11 Sep 2014 16:46:46 +0800
Message-Id: <1410425210-24789-7-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to new fields about bound violation added into struct siginfo,
this patch syncs it with general version to avoid build issue.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/mips/include/uapi/asm/siginfo.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/uapi/asm/siginfo.h b/arch/mips/include/uapi/asm/siginfo.h
index e811744..d08f83f 100644
--- a/arch/mips/include/uapi/asm/siginfo.h
+++ b/arch/mips/include/uapi/asm/siginfo.h
@@ -92,6 +92,10 @@ typedef struct siginfo {
 			int _trapno;	/* TRAP # which caused the signal */
 #endif
 			short _addr_lsb;
+			struct {
+				void __user *_lower;
+				void __user *_upper;
+			} _addr_bnd;
 		} _sigfault;
 
 		/* SIGPOLL, SIGXFSZ (To do ...)	 */
-- 
1.7.1

