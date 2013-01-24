Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161005Ab3AXUU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:20:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34503 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab3AXUT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:19:29 -0500
Date: Thu, 24 Jan 2013 12:19:12 -0800
From: tip-bot for ShuoX Liu <shuox.liu@intel.com>
Message-ID: <tip-0927b482ae69acb7605f6be1ad3860b657512fbd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, shuox.liu@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, shuox.liu@intel.com, tglx@linutronix.de
In-Reply-To: <1356713324-12442-1-git-send-email-shuox.liu@intel.com>
References: <1356713324-12442-1-git-send-email-shuox.liu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Enable Intel Lincroft/Penwell/
 Cloverview Atom support
Git-Commit-ID: 0927b482ae69acb7605f6be1ad3860b657512fbd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:19:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0927b482ae69acb7605f6be1ad3860b657512fbd
Gitweb:     http://git.kernel.org/tip/0927b482ae69acb7605f6be1ad3860b657512fbd
Author:     ShuoX Liu <shuox.liu@intel.com>
AuthorDate: Sat, 29 Dec 2012 00:48:44 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 15:10:03 +0100

perf/x86: Enable Intel Lincroft/Penwell/Cloverview Atom support

These three chip are based on Atom and have different model id.
So add such three id for perf HW event support.

Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
Cc: yanmin_zhang@intel.linux.com
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1356713324-12442-1-git-send-email-shuox.liu@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 93b9e11..cb313a5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2019,7 +2019,10 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 28: /* Atom */
-	case 54: /* Cedariew */
+	case 38: /* Lincroft */
+	case 39: /* Penwell */
+	case 53: /* Cloverview */
+	case 54: /* Cedarview */
 		memcpy(hw_cache_event_ids, atom_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
