Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaC3Xb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:31:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36557 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbaC3XZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Haavard Skinnemoen" <hskinnemoen@gmail.com>,
        "Sergei Trofimovich" <slyfox@gentoo.org>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        "Fengguang Wu" <fengguang.wu@intel.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.917680785@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 122/200] avr32: fix missing module.h causing build
 failure in mimc200/fram.c
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/avr32/boards/mimc200/fram.c | 1 +
 1 file changed, 1 insertion(+)

--- a/arch/avr32/boards/mimc200/fram.c
+++ b/arch/avr32/boards/mimc200/fram.c
@@ -11,6 +11,7 @@
 #define FRAM_VERSION	"1.0"
 
 #include <linux/miscdevice.h>
+#include <linux/module.h>
 #include <linux/proc_fs.h>
 #include <linux/mm.h>
 #include <linux/io.h>

