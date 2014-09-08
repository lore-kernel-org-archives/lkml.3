Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaIHNXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:23:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35938 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbaIHNXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:23:18 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, hpa@zytor.com,
        konrad.wilk@oracle.com, mingo@redhat.com, tglx@linutronix.de,
        Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH] xen/efi: Directly include needed headers
Date: Mon,  8 Sep 2014 15:22:18 +0200
Message-Id: <1410182538-18783-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I discovered that some needed stuff is defined/declared in headers
which are not included directly. Currently it works but if somebody
remove required headers from currently included headers then build
will break. So, just in case directly include all needed headers.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 arch/x86/xen/efi.c |    2 ++
 drivers/xen/efi.c  |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index a02e09e..be14cc3 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -15,12 +15,14 @@
  * with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/bitops.h>
 #include <linux/efi.h>
 #include <linux/init.h>
 #include <linux/string.h>
 
 #include <xen/xen-ops.h>
 
+#include <asm/page.h>
 #include <asm/setup.h>
 
 void __init xen_efi_init(void)
diff --git a/drivers/xen/efi.c b/drivers/xen/efi.c
index 31f618a..1f850c9 100644
--- a/drivers/xen/efi.c
+++ b/drivers/xen/efi.c
@@ -27,6 +27,8 @@
 #include <xen/interface/platform.h>
 #include <xen/xen.h>
 
+#include <asm/page.h>
+
 #include <asm/xen/hypercall.h>
 
 #define INIT_EFI_OP(name) \
-- 
1.7.10.4

