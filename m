Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaKKLzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:55:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57378 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbaKKLJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Triplett <josh@joshtriplett.org>, Kamal Mostafa <kamal@canonical.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 058/170] init/Kconfig: Hide printk log config if CONFIG_PRINTK=n
Date: Tue, 11 Nov 2014 11:06:57 +0000
Message-Id: <1415704129-12709-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Triplett <josh@joshtriplett.org>

commit 361e9dfbaae84b0b246ed18d1ab7c82a1a41b53e upstream.

The buffers sized by CONFIG_LOG_BUF_SHIFT and
CONFIG_LOG_CPU_MAX_BUF_SHIFT do not exist if CONFIG_PRINTK=n, so don't
ask about their size at all.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
[ kamal: backport to 3.13-stable: only LOG_BUF_SHIFT ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index 35685a46e4da..e1f5e082b26b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -806,6 +806,7 @@ config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
 	range 12 21
 	default 17
+	depends on PRINTK
 	help
 	  Select kernel log buffer size as a power of 2.
 	  Examples:
-- 
2.1.0

