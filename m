Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245Ab3CGO70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:59:26 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:18231 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab3CGO7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:59:25 -0500
Subject: [RFC PATCH 5/5] crash dump bitmap: workaround for kernel 3.9-rc1
 kdump issue
To: mingo@redhat.com, kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        hpa@zytor.com, yinghai@kernel.org, vgoyal@redhat.com
From: Jingbai Ma <jingbai.ma@hp.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 07 Mar 2013 22:59:20 +0800
Message-ID: <20130307145918.29098.28670.stgit@k.asiapacific.hpqcorp.net>
In-Reply-To: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux kernel 3.9-rc1 allows crashkernel above 4GB, but current
kexec-tools doesn't support it yet.
This patch is only a workaround to make kdump work again.
This patch should be removed after kexec-tools 2.0.4 release.

Signed-off-by: Jingbai Ma <jingbai.ma@hp.com>
---
 arch/x86/kernel/setup.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 165c831..15321d6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -506,7 +506,8 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 #ifdef CONFIG_X86_32
 # define CRASH_KERNEL_ADDR_MAX	(512 << 20)
 #else
-# define CRASH_KERNEL_ADDR_MAX	MAXMEM
+/* # define CRASH_KERNEL_ADDR_MAX	MAXMEM */
+# define CRASH_KERNEL_ADDR_MAX	(896 << 20)
 #endif
 
 static void __init reserve_crashkernel_low(void)

