Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbaKRG4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:56:24 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37260 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbaKRG4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:56:22 -0500
Subject: [PATCH] cpuidle/powernv: Re-enable fastsleep at boot time
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: mpe@ellerman.id.au, mikey@neuling.org, joel.stanley@au1.ibm.com
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Nov 2014 12:26:03 +0530
Message-ID: <20141118065603.22544.88816.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111806-0033-0000-0000-00000114189F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit dcb18694 "Fix ipi on palmeto" disabled fastsleep at boot time.
Revert this commit since we no longer need this fix. However we can
continue to use powersave_nap parameter to control entry into deep
idle states beyond snooze.

Signed-off-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
---

 drivers/cpuidle/cpuidle-powernv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index b57681d..b430e76 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -69,8 +69,9 @@ static int fastsleep_loop(struct cpuidle_device *dev,
 	unsigned long old_lpcr = mfspr(SPRN_LPCR);
 	unsigned long new_lpcr;
 
-	if (powersave_nap < 2)
-		return;
+	if (!(powersave_nap > 0))
+		return index;
+
 	if (unlikely(system_state < SYSTEM_RUNNING))
 		return index;
 

