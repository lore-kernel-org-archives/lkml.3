Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965436AbbA1E7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:59:51 -0500
Received: from mail.kernel.org ([198.145.29.136]:39289 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934062AbbA1EUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:20:37 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 73/91] init/Kconfig: Hide printk log config if CONFIG_PRINTK=n
Date: Wed, 28 Jan 2015 12:08:33 +0800
Message-Id: <1422418236-12852-146-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 361e9dfbaae84b0b246ed18d1ab7c82a1a41b53e upstream.

The buffers sized by CONFIG_LOG_BUF_SHIFT and
CONFIG_LOG_CPU_MAX_BUF_SHIFT do not exist if CONFIG_PRINTK=n, so don't
ask about their size at all.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
[lizf: Backported to 3.4:
 - drop the change to CONFIG_LOG_CPU_MAX_BUF_SHIFT as it doesn't exist in 3.4]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index 6cfd71d..f1b0e78 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -560,6 +560,7 @@ config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
 	range 12 21
 	default 17
+	depends on PRINTK
 	help
 	  Select kernel log buffer size as a power of 2.
 	  Examples:
-- 
1.9.1

