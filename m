Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaB0LqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:46:15 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41171 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaB0LqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:46:09 -0500
Date: Thu, 27 Feb 2014 17:13:53 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH 14/46] kernel: Move prototype declaration to header file
 kernel/power/power.h
Message-ID: <620346a9abff597545a6249d0d8c4adba8f1a1d9.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move prototype declaration of function to header file
kernel/power/power.h
because it is used by more than one file.

This eliminates the following warning in kernel/power/snapshot.c:
kernel/power/snapshot.c:1588:16: warning: no previous prototype for ‘swsusp_save’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/power/power.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 7d4b7ff..1ca7531 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -49,6 +49,8 @@ static inline char *check_image_kernel(struct swsusp_info *info)
  */
 #define SPARE_PAGES	((1024 * 1024) >> PAGE_SHIFT)
 
+asmlinkage int swsusp_save(void);
+
 /* kernel/power/hibernate.c */
 extern bool freezer_test_done;
 
-- 
1.7.9.5

