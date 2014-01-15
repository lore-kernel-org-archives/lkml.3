Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaAOV5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:57:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40983 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbaAOV53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 132/166] ARM: fix "bad mode in ... handler" message for undefined instructions
Date: Wed, 15 Jan 2014 13:52:26 -0800
Message-Id: <1389822780-4729-133-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 29c350bf28da333e41e30497b649fe335712a2ab upstream.

The array was missing the final entry for the undefined instruction
exception handler; this commit adds it.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kernel/traps.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 1392beb..cb49efe 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -37,7 +37,13 @@
 
 #include "signal.h"
 
-static const char *handler[]= { "prefetch abort", "data abort", "address exception", "interrupt" };
+static const char *handler[]= {
+	"prefetch abort",
+	"data abort",
+	"address exception",
+	"interrupt",
+	"undefined instruction",
+};
 
 void *vectors_page;
 
-- 
1.8.3.2

