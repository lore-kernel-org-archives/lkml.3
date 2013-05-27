Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab3E0GbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 02:31:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:44592 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3E0GbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 02:31:19 -0400
X-Spam-Score: -100.8
Message-ID: <51A2FD85.6080808@asianux.com>
Date: Mon, 27 May 2013 14:30:29 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: tony.luck@intel.com, fenghua.yu@intel.com,
        Rusty Russell <rusty@rustcorp.com.au>
CC: linux-ia64@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: [PATCH] arch: ia64: kernel: flow control, need use 'return' instead
 of 'break'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In this case, the original author did not provide the related reason
string for die_if_kernel(), so the 'buf' is not initialized.

The original author wants to generic a 'SIGSEGV' and 'return', not want
to 'break' to fall to die.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/ia64/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/traps.c b/arch/ia64/kernel/traps.c
index f7f9f9c..d3636e6 100644
--- a/arch/ia64/kernel/traps.c
+++ b/arch/ia64/kernel/traps.c
@@ -630,7 +630,7 @@ ia64_fault (unsigned long vector, unsigned long isr, unsigned long ifa,
 		printk(KERN_ERR "  iip - 0x%lx, ifa - 0x%lx, isr - 0x%lx\n",
 		       iip, ifa, isr);
 		force_sig(SIGSEGV, current);
-		break;
+		return;
 
 	      case 46:
 		printk(KERN_ERR "Unexpected IA-32 intercept trap (Trap 46)\n");
-- 
1.7.7.6
