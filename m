Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967030Ab3DQW5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 18:57:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60134 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966905Ab3DQW5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 18:57:11 -0400
Date: Wed, 17 Apr 2013 15:57:00 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-157752d84f5df47e01577970f9c5f61a0b9f4546@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        vgoyal@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, vgoyal@redhat.com,
        hpa@linux.intel.com
In-Reply-To: <1366089828-19692-3-git-send-email-yinghai@kernel.org>
References: <1366089828-19692-3-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/kdump] kexec: use Crash kernel for Crash kernel low
Git-Commit-ID: 157752d84f5df47e01577970f9c5f61a0b9f4546
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 17 Apr 2013 15:57:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  157752d84f5df47e01577970f9c5f61a0b9f4546
Gitweb:     http://git.kernel.org/tip/157752d84f5df47e01577970f9c5f61a0b9f4546
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 15 Apr 2013 22:23:46 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 17 Apr 2013 12:35:34 -0700

kexec: use Crash kernel for Crash kernel low

We can extend kexec-tools to support multiple "Crash kernel" in /proc/iomem
instead.

So we can use "Crash kernel" instead of "Crash kernel low" in /proc/iomem.

Suggested-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1366089828-19692-3-git-send-email-yinghai@kernel.org
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/kexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 401fdb0..ffd4e11 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -55,7 +55,7 @@ struct resource crashk_res = {
 	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
 };
 struct resource crashk_low_res = {
-	.name  = "Crash kernel low",
+	.name  = "Crash kernel",
 	.start = 0,
 	.end   = 0,
 	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
