Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322AbaBEUqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:46:38 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48294 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbaBEUGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 113/213] xen/bootup: allow read_tscp call for Xen PV guests.
Date: Wed, 5 Feb 2014 15:01:08 -0500
Message-ID: <1391630568-49251-114-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cd0608e71e9757f4dae35bcfb4e88f4d1a03a8ab upstream.

The hypervisor will trap it. However without this patch,
we would crash as the .read_tscp is set to NULL. This patch
fixes it and sets it to the native_read_tscp call.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/xen/enlighten.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 25d787c17ad8..7fa0dc02b939 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -952,6 +952,8 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 
+	.read_tscp = native_read_tscp,
+
 	.iret = xen_iret,
 	.irq_enable_sysexit = xen_sysexit,
 #ifdef CONFIG_X86_64
-- 
1.8.5.2

