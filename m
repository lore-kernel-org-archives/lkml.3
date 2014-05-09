Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaEILJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:09:25 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48857 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaEILJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:09:24 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, peter.chen@freescale.com
Subject: [PATCH] mfd: syscon: Include linux/err.h to fix build error
Date: Fri,  9 May 2014 16:37:40 +0530
Message-Id: <1399633660-17897-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit df73de9b0d412 ("mfd: syscon: Return -ENOSYS if CONFIG_MFD_SYSCON
is not enabled") introduced fallbacks for APIs, but missed out on adding
the header file. This would work only if linux/err.h is also included
in the source code from where this file is included. It would be better
to include linux/err.h in file to remove possible build errors.

Without this patch, we get following and similar build errors if this
header file is included in some source file and CONFIG_MFD_SYSCON is
not enabled.

include/linux/mfd/syscon.h: In function ‘syscon_node_to_regmap’:
include/linux/mfd/syscon.h:30:2: error: implicit declaration of function ‘ERR_PTR’ [-Werror=implicit-function-declaration]
  return ERR_PTR(-ENOSYS);
  ^
include/linux/mfd/syscon.h:30:18: error: ‘ENOSYS’ undeclared (first use in this function)
  return ERR_PTR(-ENOSYS);
                  ^

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 include/linux/mfd/syscon.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mfd/syscon.h b/include/linux/mfd/syscon.h
index 8789fa3..75e543b 100644
--- a/include/linux/mfd/syscon.h
+++ b/include/linux/mfd/syscon.h
@@ -15,6 +15,8 @@
 #ifndef __LINUX_MFD_SYSCON_H__
 #define __LINUX_MFD_SYSCON_H__
 
+#include <linux/err.h>
+
 struct device_node;
 
 #ifdef CONFIG_MFD_SYSCON
-- 
1.7.9.5

