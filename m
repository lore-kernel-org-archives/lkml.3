Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaJBO5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:57:53 -0400
Received: from mail-db3on0064.outbound.protection.outlook.com ([157.55.234.64]:40480
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753584AbaJBO5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:57:52 -0400
X-Greylist: delayed 960 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Oct 2014 10:57:51 EDT
Date: Thu, 2 Oct 2014 15:41:39 +0100
From: Romeo Cane <romeo.cane.ext@coriant.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] powerpc: fix sys_call_table declaration
Message-ID: <20141002144131.GA3855@rcane-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [217.115.69.135]
X-ClientProxiedBy: DB4PR07CA029.eurprd07.prod.outlook.com (10.242.229.39) To
 DBXPR04MB143.eurprd04.prod.outlook.com (10.242.140.15)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DBXPR04MB143;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(64706001)(77096002)(76482002)(33656002)(47776003)(23726002)(101416001)(105586002)(120916001)(19580395003)(10300001)(95666004)(87976001)(85852003)(85306004)(46102003)(80022003)(33716001)(20776003)(66066001)(106356001)(46406003)(42186005)(21056001)(99396003)(92566001)(54356999)(50986999)(102836001)(83506001)(86362001)(107046002)(19580405001)(31966008)(92726001)(97756001)(229853001)(4396001)(97736003)(50466002)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:DBXPR04MB143;H:rcane-VirtualBox;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: coriant.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring sys_call_table as a pointer causes the compiler to generate the wrong lookup code in arch_syscall_addr

Signed-off-by: Romeo Cane <romeo.cane.ext@coriant.com>
---
 arch/powerpc/include/asm/syscall.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/asm/syscall.h
index b54b2ad..528ba9d 100644
--- a/arch/powerpc/include/asm/syscall.h
+++ b/arch/powerpc/include/asm/syscall.h
@@ -17,7 +17,7 @@
 
 /* ftrace syscalls requires exporting the sys_call_table */
 #ifdef CONFIG_FTRACE_SYSCALLS
-extern const unsigned long *sys_call_table;
+extern const unsigned long sys_call_table[];
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
 static inline long syscall_get_nr(struct task_struct *task,
-- 
1.8.3.2

