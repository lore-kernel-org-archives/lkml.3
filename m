Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaJ0N0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:26:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40432 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377AbaJ0N03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:26:29 -0400
Subject: [PATCH] cpuidle/powernv: Fix return value of idle index in fastsleep
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: mpe@ellerman.id.au, mikey@neuling.org, joel.stanley@au1.ibm.com
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Oct 2014 18:56:18 +0530
Message-ID: <20141027132618.9085.97044.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102713-0033-0000-0000-000000DC4BC0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit dcb18694 : Fix ipi on Palmeto added a workaround to disable
going into fastsleep on Palmeto boards which was reported to fail
to boot when fastsleep was enabled. However it missed returning
an idle index. Fix this.

There is probably no harm in returning the index of fastsleep
although the cpu did not enter this state. The governor will notice
the difference in the residency time in the idle state and the
target residency of the idle state and prevent cpus from entering
fastsleep from that point on. Hence the usage and time statistics
logged for fastsleep will not be out of sync with reality except
for the first entry.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
Do we still need this workaround? Or can we get rid of the check
on powersave_nap altogether?
---

 drivers/cpuidle/cpuidle-powernv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index fa79392..c18da24 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -70,7 +70,7 @@ static int fastsleep_loop(struct cpuidle_device *dev,
 	unsigned long new_lpcr;
 
 	if (powersave_nap < 2)
-		return;
+		return index;
 	if (unlikely(system_state < SYSTEM_RUNNING))
 		return index;
 

