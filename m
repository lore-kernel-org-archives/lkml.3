Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaENDAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:00:30 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53328 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbaENDA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:00:29 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <catalin.marinas@arm.com>, <will.deacon@arm.com>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH] ARM64: kernel: add compatable cpuinfo
Date: Wed, 14 May 2014 10:59:58 +0800
Message-ID: <1400036398-16591-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-13_07:2014-05-13,2014-05-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405140041
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print the necessary features in order to be backwards compatable with
ARMv7 and earlier version.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 arch/arm64/kernel/setup.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 7ec7846..a09ecfe 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -451,6 +451,11 @@ static int c_show(struct seq_file *m, void *v)
 		if (elf_hwcap & (1 << i))
 			seq_printf(m, "%s ", hwcap_str[i]);
 
+#ifdef CONFIG_COMPAT
+	seq_puts(m, "half thumb fastmult edsp tls vfp vfpv3 vfpv4 neon ");
+	seq_puts(m, "idiva idivt ");
+#endif
+
 	seq_printf(m, "\nCPU implementer\t: 0x%02x\n", read_cpuid_id() >> 24);
 	seq_printf(m, "CPU architecture: AArch64\n");
 	seq_printf(m, "CPU variant\t: 0x%x\n", (read_cpuid_id() >> 20) & 15);
-- 
1.7.9.5

