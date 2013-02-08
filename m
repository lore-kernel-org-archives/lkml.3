Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946216Ab3BHKrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:47:23 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:58726 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964789Ab3BHKqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:46:50 -0500
From: Vijay Kumar Mishra <vijay.kumar@st.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <spear-devel@codex.cro.st.com>, <viresh.kumar@linaro.org>,
        Vijay Kumar Mishra <vijay.kumar@st.com>
Subject: [PATCH 3/3] SPEAr13xx_defconfig: Enable compilation using the latest
Date: Fri, 8 Feb 2013 16:16:31 +0530
Message-ID: <4d1cdf05ed312af2d8004496765f8fc82c27f2c1.1360317993.git.vijay.kumar@st.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1360317993.git.vijay.kumar@st.com>
References: <cover.1360317993.git.vijay.kumar@st.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This Patch is to enable CONFIG_AEABI option in kernel. Which basically adds
support for latest ARMABI (EABI).

It also include support for changes the kernel syscall calling convention to
disambiguate both ABIs and allow for backward compatibility support.

Without this option the kernel crashes. Crash log is below:

Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000004
Exception stack(0xbf873f64 to 0xbf873fac)
3f60:          00000020 804725b4 00000001 00000000 bf872000 80498684 803308bc
3f80: 80474fe8 bf872000 412fc091 00000000 bf873fb8 bf873fbc bf873fac 80009c50
3fa0: 80009c54 60000113 ffffffff
 r7:bf873f98 r6:ffffffff r5:60000113 r4:80009c54
[<80009c24>] (default_idle+0x0/0x38) from [<80009e24>] (cpu_idle+0xac/0xf0)
[<80009d78>] (cpu_idle+0x0/0xf0) from [<803277ec>]
(secondary_start_kernel+0xec/0x10c)
 r8:0000406a r7:80498950 r6:10c03c7d r5:00000001 r4:80478bd0
[<80327700>] (secondary_start_kernel+0x0/0x10c) from [<00326dc8>] (0x326dc8)
 r5:0
---
 arch/arm/configs/spear13xx_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/spear13xx_defconfig b/arch/arm/configs/spear13xx_defconfig
index 1b5ceff..4e2866d 100644
--- a/arch/arm/configs/spear13xx_defconfig
+++ b/arch/arm/configs/spear13xx_defconfig
@@ -15,6 +15,7 @@ CONFIG_SMP=y
 # CONFIG_SMP_ON_UP is not set
 # CONFIG_ARM_CPU_TOPOLOGY is not set
 CONFIG_VMSPLIT_2G=y
+CONFIG_AEABI=y
 CONFIG_ARM_APPENDED_DTB=y
 CONFIG_ARM_ATAG_DTB_COMPAT=y
 CONFIG_BINFMT_MISC=y
-- 
1.7.9.5

