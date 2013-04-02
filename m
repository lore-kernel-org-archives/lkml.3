Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab3DBRUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:20:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37882 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910Ab3DBRUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:20:37 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: WANG Chao <chaowang@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/4] kexec: use Crash kernel for Crash kernel low
Date: Tue,  2 Apr 2013 10:19:41 -0700
Message-Id: <1364923183-316-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364923183-316-1-git-send-email-yinghai@kernel.org>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
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
