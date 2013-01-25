Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab3AYWsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:48:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50638 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab3AYWp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:45:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH 03/19] ARM: msm: proc_comm_boot_wait should not be __init
Date: Fri, 25 Jan 2013 22:44:02 +0000
Message-Id: <1359153858-31992-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:eRYK/RIYWicap1wo2F5Bt/hJ3/+XF6uJIHv/8Og8PsZ
 1z65gu8svf7H+VCezKsu35CG8QX4b+cYLIsuWFa4ItAdX37hwj
 HxkHNp/8gqP8tunj/KuY77H4pnfStQxPg+zRIMO5+QRQsLnLp3
 HgSANrzL2BMf/tNiSTxCb0ByYp1SJnHOirQMrGoKLuz2OQUmRJ
 Q7gOc+Dr07Ip2txfzytIHDWtQaMaHvA6s+CB+5PdJIvj/OmIHt
 bO4s+h6o6RsgvcWglcfjfuo5wJAPgRkTCOge1GcynCVJ2su3KF
 Y3BmGV3qV9JlS2+5YAj6+ssAPLCy0O4Ni6WNzqveSoNxeysfAj
 SwbCxiydASWKM8UsnCbARAPcJRMgmVCwTfnUsR0M/
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

