Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779Ab3CZE3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 00:29:42 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:57961 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab3CZE3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 00:29:40 -0400
Message-ID: <51512431.9060309@kernel.org>
Date: Tue, 26 Mar 2013 00:29:37 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Lars-Peter Clausen <lars@metafoo.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Subject: [PATCH] ia64 idle: delete (*idle)()
References: <1360475903-30007-1-git-send-email-lenb@kernel.org> <7dc2a692a27e9c3da86acf150c4a89024e48bd05.1360475150.git.len.brown@intel.com> <5125F3D3.6040309@metafoo.de> <1A7043D5F58CCB44A599DFD55ED4C9482976B321@FMSMSX108.amr.corp.intel.com>
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C9482976B321@FMSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

3e7fc708eb (ia64 idle: delete pm_idle) in 3.9-rc1
didn't finish the job, leaving an un-initialized
reference to (*idle)().

Reported-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/ia64/kernel/process.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index e34f565..6f7dc8b 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -291,7 +291,6 @@ cpu_idle (void)
 		}
 
 		if (!need_resched()) {
-			void (*idle)(void);
 #ifdef CONFIG_SMP
 			min_xtp();
 #endif
@@ -299,9 +298,7 @@ cpu_idle (void)
 			if (mark_idle)
 				(*mark_idle)(1);
 
-			if (!idle)
-				idle = default_idle;
-			(*idle)();
+			default_idle();
 			if (mark_idle)
 				(*mark_idle)(0);
 #ifdef CONFIG_SMP
-- 

