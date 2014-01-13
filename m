Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaAMOpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:45:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51456 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaAMO02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 60/96] powerpc: Align p_end
Date: Mon, 13 Jan 2014 14:24:23 +0000
Message-Id: <1389623099-18783-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 286e4f90a72c0b0621dde0294af6ed4b0baddabb upstream.

p_end is an 8 byte value embedded in the text section. This means it
is only 4 byte aligned when it should be 8 byte aligned. Fix this
by adding an explicit alignment.

This fixes an issue where POWER7 little endian builds with
CONFIG_RELOCATABLE=y fail to boot.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/head_64.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 1a3607b..1a5b687 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -447,6 +447,7 @@ _STATIC(__after_prom_start)
 	mtctr	r8
 	bctr
 
+.balign 8
 p_end:	.llong	_end - _stext
 
 4:	/* Now copy the rest of the kernel up to _end */
-- 
1.8.3.2

