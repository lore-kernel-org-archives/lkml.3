Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab3LRWOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:14:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3LRVLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:11:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.10 12/78] ARM: 7913/1: fix framepointer check in unwind_frame
Date: Wed, 18 Dec 2013 13:10:40 -0800
Message-Id: <20131218211112.254184940@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>

commit 3abb6671a9c04479c4bd026798a05f857393b7e2 upstream.

This patch fixes corner case when (fp + 4) overflows unsigned long,
for example: fp = 0xFFFFFFFF -> fp + 4 == 3.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/stacktrace.c |    2 +-
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


