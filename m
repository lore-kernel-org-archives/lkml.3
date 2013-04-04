Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3DDAjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 20:39:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23736 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762367Ab3DDAjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 20:39:14 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 3/4] kexec: use Crash kernel for Crash kernel low
Date: Wed,  3 Apr 2013 17:38:24 -0700
Message-Id: <1365035906-3208-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365035906-3208-1-git-send-email-yinghai@kernel.org>
References: <1365035906-3208-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can extend kexec-tools to support multiple "Crash kernel" in /proc/iomem
instead.

So we can use "Crash kernel" instead of "Crash kernel low" in /proc/iomem.

Suggested-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c
+++ linux-2.6/kernel/kexec.c
@@ -55,7 +55,7 @@ struct resource crashk_res = {
 	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
 };
 struct resource crashk_low_res = {
-	.name  = "Crash kernel low",
+	.name  = "Crash kernel",
 	.start = 0,
 	.end   = 0,
 	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
