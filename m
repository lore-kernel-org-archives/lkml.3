Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaAMQiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:38:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53327 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbaAMQD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:26 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 107/208] powerpc: Align p_end
Date: Mon, 13 Jan 2014 15:59:08 +0000
Message-Id: <1389628849-1614-108-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

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
index b61363d..192a3f5 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -467,6 +467,7 @@ _STATIC(__after_prom_start)
 	mtctr	r8
 	bctr
 
+.balign 8
 p_end:	.llong	_end - _stext
 
 4:	/* Now copy the rest of the kernel up to _end */
-- 
1.8.3.2

