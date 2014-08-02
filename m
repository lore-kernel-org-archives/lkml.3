Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaHBXzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 19:55:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaHBXzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 19:55:49 -0400
Date: Sat, 2 Aug 2014 16:55:08 -0700
From: tip-bot for Dan Carpenter <tipbot@zytor.com>
Message-ID: <tip-4c51cb005b29e6329d7e598bf835689b230817c9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, aubrey.li@linux.intel.com,
        dan.carpenter@oracle.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dan.carpenter@oracle.com,
        aubrey.li@linux.intel.com
In-Reply-To: <20140801082715.GE28869@mwanda>
References: <20140801082715.GE28869@mwanda>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/pmc_atom:
  Silence shift wrapping warnings in pmc_sleep_tmr_show()
Git-Commit-ID: 4c51cb005b29e6329d7e598bf835689b230817c9
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

Commit-ID:  4c51cb005b29e6329d7e598bf835689b230817c9
Gitweb:     http://git.kernel.org/tip/4c51cb005b29e6329d7e598bf835689b230817c9
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Fri, 1 Aug 2014 11:27:15 +0300
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 2 Aug 2014 16:52:17 -0700

x86/pmc_atom: Silence shift wrapping warnings in pmc_sleep_tmr_show()

I don't know if we really need 64 bits here but these variables are
declared as u64 and it can't hurt to cast this so we prevent any shift
wrapping.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Aubrey Li <aubrey.li@linux.intel.com>
Link: http://lkml.kernel.org/r/20140801082715.GE28869@mwanda
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/pmc_atom.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 0d92ef6..0c424a6 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -174,11 +174,11 @@ static int pmc_sleep_tmr_show(struct seq_file *s, void *unused)
 	struct pmc_dev *pmc = s->private;
 	u64 s0ir_tmr, s0i1_tmr, s0i2_tmr, s0i3_tmr, s0_tmr;
 
-	s0ir_tmr = pmc_reg_read(pmc, PMC_S0IR_TMR) << PMC_TMR_SHIFT;
-	s0i1_tmr = pmc_reg_read(pmc, PMC_S0I1_TMR) << PMC_TMR_SHIFT;
-	s0i2_tmr = pmc_reg_read(pmc, PMC_S0I2_TMR) << PMC_TMR_SHIFT;
-	s0i3_tmr = pmc_reg_read(pmc, PMC_S0I3_TMR) << PMC_TMR_SHIFT;
-	s0_tmr = pmc_reg_read(pmc, PMC_S0_TMR) << PMC_TMR_SHIFT;
+	s0ir_tmr = (u64)pmc_reg_read(pmc, PMC_S0IR_TMR) << PMC_TMR_SHIFT;
+	s0i1_tmr = (u64)pmc_reg_read(pmc, PMC_S0I1_TMR) << PMC_TMR_SHIFT;
+	s0i2_tmr = (u64)pmc_reg_read(pmc, PMC_S0I2_TMR) << PMC_TMR_SHIFT;
+	s0i3_tmr = (u64)pmc_reg_read(pmc, PMC_S0I3_TMR) << PMC_TMR_SHIFT;
+	s0_tmr = (u64)pmc_reg_read(pmc, PMC_S0_TMR) << PMC_TMR_SHIFT;
 
 	seq_printf(s, "S0IR Residency:\t%lldus\n", s0ir_tmr);
 	seq_printf(s, "S0I1 Residency:\t%lldus\n", s0i1_tmr);
