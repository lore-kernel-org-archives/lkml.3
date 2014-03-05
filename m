Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbaCEOx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:53:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41612 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbaCEOhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 17/62] avr32: fix missing module.h causing build failure in mimc200/fram.c
Date: Wed,  5 Mar 2014 14:36:21 +0000
Message-Id: <1394030226-26652-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit 5745d6a41a4f4aec29e2ccd591c6fb09ed73a955 upstream.

Causing this:

In file included from arch/avr32/boards/mimc200/fram.c:13:
include/linux/miscdevice.h:51: error: field 'list' has incomplete type
include/linux/miscdevice.h:55: error: expected specifier-qualifier-list before 'mode_t'
arch/avr32/boards/mimc200/fram.c:42: error: 'THIS_MODULE' undeclared here (not in a function)

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/avr32/boards/mimc200/fram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/avr32/boards/mimc200/fram.c b/arch/avr32/boards/mimc200/fram.c
index 9764a1a..c1466a8 100644
--- a/arch/avr32/boards/mimc200/fram.c
+++ b/arch/avr32/boards/mimc200/fram.c
@@ -11,6 +11,7 @@
 #define FRAM_VERSION	"1.0"
 
 #include <linux/miscdevice.h>
+#include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/mm.h>
 #include <linux/io.h>
-- 
1.9.0

