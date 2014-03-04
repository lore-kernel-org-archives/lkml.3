Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbaCDUDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:03:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbaCDUC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:02:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 3.13 027/172] avr32: fix missing module.h causing build failure in mimc200/fram.c
Date: Tue,  4 Mar 2014 12:01:51 -0800
Message-Id: <20140304200300.598244174@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/avr32/boards/mimc200/fram.c |    1 +
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


