Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab3AOWpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:45:07 -0500
Received: from mail.kernel.org ([198.145.19.201]:44836 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932764Ab3AOWo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:44:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 004/171] powerpc: Fix CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n build
Date: Tue, 15 Jan 2013 14:42:49 -0800
Message-Id: <20130115224313.726940123@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 11ee7e99f35ecb15f59b21da6a82d96d2cd3fcc8 upstream.

If we build a kernel with CONFIG_RELOCATABLE=y CONFIG_CRASH_DUMP=n,
the kernel fails when we run at a non zero offset. It turns out
we were incorrectly wrapping some of the relocatable kernel code
with CONFIG_CRASH_DUMP.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -422,7 +422,7 @@ _STATIC(__after_prom_start)
 	tovirt(r6,r6)			/* on booke, we already run at PAGE_OFFSET */
 #endif
 
-#ifdef CONFIG_CRASH_DUMP
+#ifdef CONFIG_RELOCATABLE
 /*
  * Check if the kernel has to be running as relocatable kernel based on the
  * variable __run_at_load, if it is set the kernel is treated as relocatable


