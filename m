Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240AbaGWULA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:11:00 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53720 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932825AbaGWUK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:10:58 -0400
X-Sasl-enc: DssHIsuBPFUFjNU6iySEwu4M/SrZ7zQYC/SJnm6Axk8Y 1406146257
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: H Peter Anvin <hpa@zytor.com>
Subject: [PATCH 2/8] x86, microcode, intel: fix missing static declarations
Date: Wed, 23 Jul 2014 17:10:45 -0300
Message-Id: <1406146251-8540-3-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc reports that a few declarations are missing.
Fix two obvious ones.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 arch/x86/kernel/cpu/microcode/intel_early.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/intel_early.c b/arch/x86/kernel/cpu/microcode/intel_early.c
index 18f7391..b105c11 100644
--- a/arch/x86/kernel/cpu/microcode/intel_early.c
+++ b/arch/x86/kernel/cpu/microcode/intel_early.c
@@ -28,8 +28,8 @@
 #include <asm/tlbflush.h>
 #include <asm/setup.h>
 
-unsigned long mc_saved_in_initrd[MAX_UCODE_COUNT];
-struct mc_saved_data {
+static unsigned long mc_saved_in_initrd[MAX_UCODE_COUNT];
+static struct mc_saved_data {
 	unsigned int mc_saved_count;
 	struct microcode_intel **mc_saved;
 } mc_saved_data;
-- 
1.7.10.4

