Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab3KMLRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 06:17:09 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:65328 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3KMLRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 06:17:06 -0500
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jonathan Austin <jonathan.austin@arm.com>, <stable@vger.kernel.org>,
        Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/2] ARM: default PHYS_OFFSET if !MMU
Date: Wed, 13 Nov 2013 19:15:50 +0800
Message-Id: <1384341351-4110-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384341351-4110-1-git-send-email-tom.leiming@gmail.com>
References: <1384341351-4110-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Austin <jonathan.austin@arm.com>

Set CONFIG_PAGE_OFFSET as PHYS_OFFSET when !MMU so that
we can keep CONFIG_PAGE_OFFSET same with PAGE_OFFSET.
 
This patch and patch 2/2 fix regression on !MMU by
f6537f2f0eba4eba("scripts/kallsyms: filter symbols not
in kernel address space")

Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 arch/arm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 799ef94..db708c4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1560,6 +1560,7 @@ endchoice
 
 config PAGE_OFFSET
 	hex
+	default PHYS_OFFSET if !MMU
 	default 0x40000000 if VMSPLIT_1G
 	default 0x80000000 if VMSPLIT_2G
 	default 0xC0000000
-- 
1.7.9.5

