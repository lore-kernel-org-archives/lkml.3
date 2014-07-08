Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbaGHAHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:07:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbaGHADa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 38/44] powerpc/smp: Section mismatch from smp_release_cpus to __initdata spinning_secondaries
Date: Mon,  7 Jul 2014 17:07:28 -0700
Message-Id: <20140707235859.778543954@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
References: <20140707235858.652771077@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Gang <gang.chen@asianux.com>

commit 8246aca7058f3f2c2ae503081777965cd8df7b90 upstream.

the smp_release_cpus is a normal funciton and called in normal environments,
  but it calls the __initdata spinning_secondaries.
  need modify spinning_secondaries to match smp_release_cpus.

the related warning:
  (the linker report boot_paca.33377, but it should be spinning_secondaries)

-----------------------------------------------------------------------------

WARNING: arch/powerpc/kernel/built-in.o(.text+0x23176): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33377
The function .smp_release_cpus() references
the variable __initdata boot_paca.33377.
This is often because .smp_release_cpus lacks a __initdata
annotation or the annotation of boot_paca.33377 is wrong.

WARNING: arch/powerpc/kernel/built-in.o(.text+0x231fe): Section mismatch in reference from the function .smp_release_cpus() to the variable .init.data:boot_paca.33377
The function .smp_release_cpus() references
the variable __initdata boot_paca.33377.
This is often because .smp_release_cpus lacks a __initdata
annotation or the annotation of boot_paca.33377 is wrong.

-----------------------------------------------------------------------------

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/setup_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -76,7 +76,7 @@
 #endif
 
 int boot_cpuid = 0;
-int __initdata spinning_secondaries;
+int spinning_secondaries;
 u64 ppc64_pft_size;
 
 /* Pick defaults since we might want to patch instructions


