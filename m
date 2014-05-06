Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbaEFOMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:12:49 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:57050 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaEFOMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:12:47 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: Describe required sort order for textofs-y (TEXT_OFFSET)
Date: Tue,  6 May 2014 15:12:28 +0100
Message-Id: <1399385548-17892-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The section of the makefile that determines the TEXT_OFFSET is sorted
by address so that, in multi-arch kernel builds, the architecture with the
most stringent requirements for the kernel base address gets to define
TEXT_OFFSET. The comment should reflect that.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 arch/arm/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 41c1931..6857fec 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -127,6 +127,9 @@ CHECKFLAGS	+= -D__arm__
 
 #Default value
 head-y		:= arch/arm/kernel/head$(MMUEXT).o
+
+# Text offset. This list is sorted numerically by address in order to
+# provide a means to avoid/resolve conflicts in multi-arch kernels.
 textofs-y	:= 0x00008000
 textofs-$(CONFIG_ARCH_CLPS711X) := 0x00028000
 # We don't want the htc bootloader to corrupt kernel during resume
-- 
1.9.0

