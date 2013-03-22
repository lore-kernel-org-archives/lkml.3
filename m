Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004Ab3CVB1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:27:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912Ab3CVB1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:27:09 -0400
Date: Thu, 21 Mar 2013 18:24:52 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-f564c24103f87dc740c1c293c975565ac46b12ef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, sruffell@digium.com,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        sruffell@digium.com
In-Reply-To: <20130320170310.GA23362@digium.com>
References: <20130320170310.GA23362@digium.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode_intel_early:
  Mark apply_microcode_early() as cpuinit
Git-Commit-ID: f564c24103f87dc740c1c293c975565ac46b12ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 18:24:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f564c24103f87dc740c1c293c975565ac46b12ef
Gitweb:     http://git.kernel.org/tip/f564c24103f87dc740c1c293c975565ac46b12ef
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 21 Mar 2013 17:32:36 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 21 Mar 2013 17:32:36 -0700

x86, microcode_intel_early: Mark apply_microcode_early() as cpuinit

Add missing __cpuinit annotation to apply_microcode_early().

Reported-by: Shaun Ruffell <sruffell@digium.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/20130320170310.GA23362@digium.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/microcode_intel_early.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 5992ee8..d893e8e 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -659,8 +659,8 @@ static inline void __cpuinit print_ucode(struct ucode_cpu_info *uci)
 }
 #endif
 
-static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
-				 struct ucode_cpu_info *uci)
+static int __cpuinit apply_microcode_early(struct mc_saved_data *mc_saved_data,
+					   struct ucode_cpu_info *uci)
 {
 	struct microcode_intel *mc_intel;
 	unsigned int val[2];
