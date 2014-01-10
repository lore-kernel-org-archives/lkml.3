Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaAJO37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:29:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:63633 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaAJO35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:29:57 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH] avr32: fix missing module.h causing build failure in mimc200/fram.c
Date: Fri, 10 Jan 2014 09:29:39 -0500
Message-ID: <1389364179-18228-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Causing this:

In file included from arch/avr32/boards/mimc200/fram.c:13:
include/linux/miscdevice.h:51: error: field 'list' has incomplete type
include/linux/miscdevice.h:55: error: expected specifier-qualifier-list before 'mode_t'
arch/avr32/boards/mimc200/fram.c:42: error: 'THIS_MODULE' undeclared here (not in a function)

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/avr32/boards/mimc200/fram.c b/arch/avr32/boards/mimc200/fram.c
index 9764a1a1073e..c1466a872b9c 100644
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
1.8.5.2

