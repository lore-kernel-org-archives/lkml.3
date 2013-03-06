Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3CFHJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:09:37 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49851 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451Ab3CFHJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:09:35 -0500
From: Will Deacon <will.deacon@arm.com>
To: mattst88@gmail.com
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        David Rusling <david.rusling@linaro.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] alpha: boot: fix build breakage introduced by system.h disintegration
Date: Wed,  6 Mar 2013 07:09:20 +0000
Message-Id: <1362553760-23588-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ec2212088c42 ("Disintegrate asm/system.h for Alpha") removed the
system.h include from boot/head.S, which puts the PAL_* asm constants
out of scope.

Include <asm/pal.h> so we can get building again.

Cc: David Rusling <david.rusling@linaro.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/alpha/boot/head.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/alpha/boot/head.S b/arch/alpha/boot/head.S
index b06812b..8efb266 100644
--- a/arch/alpha/boot/head.S
+++ b/arch/alpha/boot/head.S
@@ -4,6 +4,7 @@
  * initial bootloader stuff..
  */
 
+#include <asm/pal.h>
 
 	.set noreorder
 	.globl	__start
-- 
1.8.1.5

