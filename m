Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaGUFmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 01:42:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:61456 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbaGUFmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 01:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="576270849"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v7 06/10] mips: sync struct siginfo with general version
Date: Mon, 21 Jul 2014 13:38:40 +0800
Message-Id: <1405921124-4230-7-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
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

