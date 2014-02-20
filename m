Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaBTRou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:44:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbaBTRot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:44:49 -0500
Date: Thu, 20 Feb 2014 12:44:23 -0500
From: Kyle McMartin <kyle@redhat.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] arm/Kconfig.debug: CONFIG_DEBUG_SET_MODULE_RONX and insn
 patching are mutually exclusive
Message-ID: <20140220174422.GA27412@redacted.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With both options set, we're seeing an Oops while loading bridge.ko, as
netfilter is trying to use jump labels on the module .text after it's
been marked read-only. I'll cook up a patch to do what X86 does and
remap the page read-write while it's being patched, but for 3.14, we
should mark them as exclusive so others don't hit this crash.

Signed-off-by: Kyle McMartin <kyle@redhat.com>

--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1197,7 +1197,7 @@ config PID_IN_CONTEXTIDR
 
 config DEBUG_SET_MODULE_RONX
 	bool "Set loadable kernel module data as NX and text as RO"
-	depends on MODULES
+	depends on MODULES && !(JUMP_LABEL || KPROBES)
 	---help---
 	  This option helps catch unintended modifications to loadable
 	  kernel module's text and read-only data. It also prevents execution
