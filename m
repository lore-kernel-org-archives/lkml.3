Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbaEQNh4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:37:56 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:57452 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbaEQNhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:37:55 -0400
Message-ID: <1400333872.13824.12.camel@x220>
Subject: [PATCH] ia64: remove check for CONFIG_IA64_FW_EMU
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 17 May 2014 15:37:52 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 May 2014 13:37:52.0887 (UTC) FILETIME=[33D91070:01CF71D5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config macro CONFIG_IA64_FW_EMU briefly appeared in the v2.3
development cycle. It would apparently have allowed to emulate
"PAL/SAL/EFI firmware". It was abandoned before v2.4.0. Finally remove
its last traces.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/ia64/kernel/head.S | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/ia64/kernel/head.S b/arch/ia64/kernel/head.S
index a4acddad0c78..d047701bf513 100644
--- a/arch/ia64/kernel/head.S
+++ b/arch/ia64/kernel/head.S
@@ -437,11 +437,6 @@ num_hypervisor_hooks = (. - hypervisor_setup_hooks) / 8
 
 	// This is executed by the bootstrap processor (bsp) only:
 
-#ifdef CONFIG_IA64_FW_EMU
-	// initialize PAL & SAL emulator:
-	br.call.sptk.many rp=sys_fw_init
-.ret1:
-#endif
 	br.call.sptk.many rp=start_kernel
 .ret2:	addl r3=@ltoff(halt_msg),gp
 	;;
-- 
1.9.0

