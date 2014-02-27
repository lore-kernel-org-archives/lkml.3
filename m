Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaB0QbC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:31:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57153 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaB0Qa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:30:59 -0500
Date: Thu, 27 Feb 2014 08:30:48 -0800
From: tip-bot for Ross Zwisler <tipbot@zytor.com>
Message-ID: <tip-2a0788dc9bc46789ec98aea0f30c6fb420196b12@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ross.zwisler@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1393441612-19729-5-git-send-email-ross.zwisler@linux.intel.com>
References: <1393441612-19729-5-git-send-email-ross.zwisler@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Use clflushopt in drm_clflush_virt_range
Git-Commit-ID: 2a0788dc9bc46789ec98aea0f30c6fb420196b12
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a0788dc9bc46789ec98aea0f30c6fb420196b12
Gitweb:     http://git.kernel.org/tip/2a0788dc9bc46789ec98aea0f30c6fb420196b12
Author:     Ross Zwisler <ross.zwisler@linux.intel.com>
AuthorDate: Wed, 26 Feb 2014 12:06:52 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 27 Feb 2014 08:26:31 -0800

x86: Use clflushopt in drm_clflush_virt_range

If clflushopt is available on the system, use it instead of clflush in
drm_clflush_virt_range.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Link: http://lkml.kernel.org/r/1393441612-19729-5-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/gpu/drm/drm_cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index c518fb6..534cb89 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -139,7 +139,7 @@ drm_clflush_virt_range(char *addr, unsigned long length)
 		mb();
 		for (; addr < end; addr += boot_cpu_data.x86_clflush_size)
 			clflush(addr);
-		clflush(end - 1);
+		clflushopt(end - 1);
 		mb();
 		return;
 	}
