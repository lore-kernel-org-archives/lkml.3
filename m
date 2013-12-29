Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab3L2Cts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:49:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55204 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab3L2CKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:14 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Russell King" <rmk+kernel@arm.linux.org.uk>,
        "Konstantin Khlebnikov" <k.khlebnikov@samsung.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.513140252@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 128/185] ARM: 7913/1: fix framepointer check in
 unwind_frame
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

commit 3abb6671a9c04479c4bd026798a05f857393b7e2 upstream.

This patch fixes corner case when (fp + 4) overflows unsigned long,
for example: fp = 0xFFFFFFFF -> fp + 4 == 3.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/stacktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/stacktrace.c
+++ b/arch/arm/kernel/stacktrace.c
@@ -31,7 +31,7 @@ int notrace unwind_frame(struct stackfra
 	high = ALIGN(low, THREAD_SIZE);
 
 	/* check current frame pointer is within bounds */
-	if (fp < (low + 12) || fp + 4 >= high)
+	if (fp < low + 12 || fp > high - 4)
 		return -EINVAL;
 
 	/* restore the registers from the stack frame */

