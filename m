Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbbALSa5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:30:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58399 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246AbbALSat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 192/216] arm64: kernel: add missing __init section marker to cpu_suspend_init
Date: Mon, 12 Jan 2015 18:29:30 +0000
Message-Id: <1421087394-2712-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>

commit 18ab7db6b749ac27aac08d572afbbd2f4d937934 upstream.

Suspend init function must be marked as __init, since it is not needed
after the kernel has booted. This patch moves the cpu_suspend_init()
function to the __init section.

Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ luis: 3.16-stable prereq for
  f43c27188a49 "arm64: kernel: fix __cpu_suspend mm switch on warm-boot" ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/kernel/suspend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
index 1fa9ce4afd8f..55a99b9a97e0 100644
--- a/arch/arm64/kernel/suspend.c
+++ b/arch/arm64/kernel/suspend.c
@@ -119,7 +119,7 @@ int cpu_suspend(unsigned long arg)
 extern struct sleep_save_sp sleep_save_sp;
 extern phys_addr_t sleep_idmap_phys;
 
-static int cpu_suspend_init(void)
+static int __init cpu_suspend_init(void)
 {
 	void *ctx_ptr;
 
-- 
2.1.4

