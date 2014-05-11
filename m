Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932929AbaEKTWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:22:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbaEKTWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:22:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.14 18/83] powerpc/compat: 32-bit little endian machine name is ppcle, not ppc
Date: Sun, 11 May 2014 21:19:19 +0200
Message-Id: <20140511191909.568615993@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 422b9b9684db3c511e65c91842275c43f5910ae9 upstream.

I noticed this when testing setarch. No, we don't magically
support a big endian userspace on a little endian kernel.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/compat.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/include/asm/compat.h
+++ b/arch/powerpc/include/asm/compat.h
@@ -8,7 +8,11 @@
 #include <linux/sched.h>
 
 #define COMPAT_USER_HZ		100
+#ifdef __BIG_ENDIAN__
 #define COMPAT_UTS_MACHINE	"ppc\0\0"
+#else
+#define COMPAT_UTS_MACHINE	"ppcle\0\0"
+#endif
 
 typedef u32		compat_size_t;
 typedef s32		compat_ssize_t;


