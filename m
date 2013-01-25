Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab3AYOO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:14:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57253 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3AYOOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:14:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <c_dwalke@quicinc.com>, linux-arm-msm@vger.kernel.org
Subject: [PATCH 03/19] ARM: msm: proc_comm_boot_wait should not be __init
Date: Fri, 25 Jan 2013 14:14:20 +0000
Message-Id: <1359123276-15833-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:0eiu5qxArP3YOQSzEEdzfyqsT9xPutK+/G7EUdCf6wK
 6Xyc6LWSOZbYmc2ZDY8kyUqblw8r30EAGnD0N2hwhk8+2XoDfW
 hN5Zp90qT3QyKZMoh1qZs5h8LawsFewbax+PUq4P+NSpD8rddw
 HrjlkEzYOjtXDbFIZU9pt6pPdIBWGlY6izEY0bXA0H88wf2vRJ
 cDHjo3MEE+8S6GY9g5nZ70sjTzSjFQ8PIo/5ZYbwTbF5t/ETcA
 RHKoKnIaA9drWF5p1GEkC56lcLmGP8qImg1IxOs1+oa8D4MD0l
 +yj9ap6V/LFIt75uu4d5eYigSoSYxGiBQdMuxlQKpKT8LyQ6Yi
 3n8EOvCGJaILDaNr6VIFhxYdV3/qsNMJ5O7/BZZ0/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

msm_smd_probe is a driver probe function and may get
called after the __init time, so it must not call
any __init function, as the link-time warning reports.
Take away the __init annotation on proc_comm_boot_wait
to fix this.

Without this patch, building msm_defconfig results in:

WARNING: vmlinux.o(.text+0xb048): Section mismatch in reference from the function msm_smd_probe() to the function .init.text:proc_comm_boot_wait()
The function msm_smd_probe() references
the function __init proc_comm_boot_wait().
This is often because msm_smd_probe lacks a __init
annotation or the annotation of proc_comm_boot_wait is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Brown <davidb@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>
Cc: Daniel Walker <c_dwalke@quicinc.com>
Cc: linux-arm-msm@vger.kernel.org
---
 arch/arm/mach-msm/proc_comm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-msm/proc_comm.h b/arch/arm/mach-msm/proc_comm.h
index 12da4ca..e8d043a 100644
--- a/arch/arm/mach-msm/proc_comm.h
+++ b/arch/arm/mach-msm/proc_comm.h
@@ -253,6 +253,6 @@ enum {
 		(((drvstr) & 0xF) << 17))
 
 int msm_proc_comm(unsigned cmd, unsigned *data1, unsigned *data2);
-void __init proc_comm_boot_wait(void);
+void proc_comm_boot_wait(void);
 
 #endif
-- 
1.8.0

