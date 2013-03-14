Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab3CNN01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:26:27 -0400
Received: from mail.windriver.com ([147.11.1.11]:63318 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732Ab3CNN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:26:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] export.h: clarify comment in relation to avoiding includes
Date: Thu, 14 Mar 2013 09:26:13 -0400
Message-ID: <1363267573-2146-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing comment indicated what was desired, but it didn't
necessarily convey the reasoning behind it in an effective way.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 include/linux/export.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/export.h b/include/linux/export.h
index 696c0f4..d14cf26 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -5,8 +5,9 @@
  * to reduce the amount of pointless cruft we feed to gcc when only
  * exporting a simple symbol or two.
  *
- * If you feel the need to add #include <linux/foo.h> to this file
- * then you are doing something wrong and should go away silently.
+ * More specifically, it was all the #include <linux/foo.h> lines in
+ * module.h that we wanted to avoid, so please avoid adding any such
+ * similar include lines here, if at all possible.
  */
 
 /* Some toolchains use a `_' prefix for all user symbols. */
-- 
1.8.1.2

