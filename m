Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbaIIEAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 00:00:12 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:58014 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIIEAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 00:00:11 -0400
From: Yang Yingliang <yangyingliang@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <catalin.marinas@arm.com>, <will.deacon@arm.com>
Subject: [PATCH] arm64: add guard macro of unistd.h to prevent double inclusion
Date: Tue, 9 Sep 2014 11:59:45 +0800
Message-ID: <1410235185-16652-1-git-send-email-yangyingliang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.18.231]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add guard macros in both uapi/asm/unistd.h and asm/unistd.h.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 arch/arm64/include/asm/unistd.h      | 5 +++++
 arch/arm64/include/uapi/asm/unistd.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/unistd.h b/arch/arm64/include/asm/unistd.h
index 6d2bf41..21a7dec 100644
--- a/arch/arm64/include/asm/unistd.h
+++ b/arch/arm64/include/asm/unistd.h
@@ -13,6 +13,9 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
+#ifndef __ASM_ARM64_UNISTD_H
+#define __ASM_ARM64_UNISTD_H
+
 #ifdef CONFIG_COMPAT
 #define __ARCH_WANT_COMPAT_SYS_GETDENTS64
 #define __ARCH_WANT_COMPAT_STAT64
@@ -48,3 +51,5 @@
 #include <uapi/asm/unistd.h>
 
 #define NR_syscalls (__NR_syscalls)
+
+#endif /* __ASM_ARM64_UNISTD_H */
diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi/asm/unistd.h
index 1caadc2..ab72cac 100644
--- a/arch/arm64/include/uapi/asm/unistd.h
+++ b/arch/arm64/include/uapi/asm/unistd.h
@@ -13,4 +13,9 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
+#ifndef _UAPI__ASM_ARM64_UNISTD_H
+#define _UAPI__ASM_ARM64_UNISTD_H
+
 #include <asm-generic/unistd.h>
+
+#endif /* _UAPI__ASM_ARM64_UNISTD_H */
-- 
1.8.0


