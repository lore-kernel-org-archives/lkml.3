Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaC1Rjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:39:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbaC1RbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        David Daney <david.daney@cavium.com>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH 3.13 27/46] MIPS: Fix build error seen in some configurations
Date: Fri, 28 Mar 2014 10:32:11 -0700
Message-Id: <20140328173138.320067821@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 63238f2cc5518e1c45a3418fc0ac0f560dafe7ef upstream.

The following build error is seen if CONFIG_32BIT is undefined,
CONFIG_64BIT is defined, and CONFIG_MIPS32_O32 is undefined.

asm/syscall.h: In function 'mips_get_syscall_arg':
arch/mips/include/asm/syscall.h:32:16: error: unused variable 'usp' [-Werror=unused-variable]
cc1: all warnings being treated as errors

Fixes: c0ff3c53d4f9 ('MIPS: Enable HAVE_ARCH_TRACEHOOK')
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: David Daney <david.daney@cavium.com>
Signed-off-by: John Crispin <blogic@openwrt.org>
Patchwork: http://patchwork.linux-mips.org/patch/6160/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/syscall.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/syscall.h
+++ b/arch/mips/include/asm/syscall.h
@@ -29,7 +29,7 @@ static inline long syscall_get_nr(struct
 static inline unsigned long mips_get_syscall_arg(unsigned long *arg,
 	struct task_struct *task, struct pt_regs *regs, unsigned int n)
 {
-	unsigned long usp = regs->regs[29];
+	unsigned long usp __maybe_unused = regs->regs[29];
 
 	switch (n) {
 	case 0: case 1: case 2: case 3:


