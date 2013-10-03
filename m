Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab3JCFXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:23:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab3JCEPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:15:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: [ 49/52] ARM: mxs: stub out mxs_pm_init for !CONFIG_PM
Date: Wed,  2 Oct 2013 21:06:07 -0700
Message-Id: <20131003040525.582962146@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 7a9caf59f60e55a8caf96f856713bd0ef0cc25a7 upstream.

When building a kernel without CONFIG_PM, we get a link
error from referencing mxs_pm_init in the machine
descriptor. This defines a macro to NULL for that case.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-mxs/pm.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm/mach-mxs/pm.h
+++ b/arch/arm/mach-mxs/pm.h
@@ -9,6 +9,10 @@
 #ifndef __ARCH_MXS_PM_H
 #define __ARCH_MXS_PM_H
 
+#ifdef CONFIG_PM
 void mxs_pm_init(void);
+#else
+#define mxs_pm_init NULL
+#endif
 
 #endif


