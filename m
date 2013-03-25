Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab3CYCtA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 22:49:00 -0400
Received: from intranet.asianux.com ([58.214.24.6]:8930 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab3CYCs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 22:48:59 -0400
X-Spam-Score: -100.8
Message-ID: <514FBAFC.60503@asianux.com>
Date: Mon, 25 Mar 2013 10:48:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: apw@canonical.com, Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] scripts/checkpatch.pl: an issue about checking failed
 for a patch
References: <514FB826.9020302@asianux.com>
In-Reply-To: <514FB826.9020302@asianux.com>
X-Forwarded-Message-Id: <514FB826.9020302@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

  when I use ./scripts/checkpatch.pl to check a patch,
    it reports a style issue.
    but after check, I can not find issue.
      (I use "static inline void" instead of "static void inline")

  please help check.

  thanks.


the related issue is:

--------------------------------------------------------------------------------------------------------------------------------
[root@gchenlinux linux-next]# ./scripts/checkpatch.pl  /tmp/0003-include-linux-platform_data-beautify-code-inline-is-.patch 
WARNING: line over 80 characters
#22: FILE: include/linux/platform_data/usb-ohci-s3c2410.h:34:
+static inline void s3c2410_usb_report_oc(struct s3c2410_hcd_info *info, int ports)

total: 0 errors, 1 warnings, 8 lines checked

/tmp/0003-include-linux-platform_data-beautify-code-inline-is-.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
--------------------------------------------------------------------------------------------------------------------------------




the related patch is :
  ("/tmp/0003-include-linux-platform_data-beautify-code-inline-is-.patch")


>From e8be21fd7b7126847a6ddfea5ac002c2ca2ca194 Mon Sep 17 00:00:00 2001
From: Chen Gang <gang.chen@asianux.com>
Date: Mon, 25 Mar 2013 10:25:53 +0800
Subject: [PATCH] include/linux/platform_data: beautify code, 'inline' is better in front of 'void'

  better to let 'inline' in front of 'void'

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/linux/platform_data/usb-ohci-s3c2410.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/platform_data/usb-ohci-s3c2410.h b/include/linux/platform_data/usb-ohci-s3c2410.h
index 7fa1fbe..cc7554a 100644
--- a/include/linux/platform_data/usb-ohci-s3c2410.h
+++ b/include/linux/platform_data/usb-ohci-s3c2410.h
@@ -31,7 +31,7 @@ struct s3c2410_hcd_info {
 	void		(*report_oc)(struct s3c2410_hcd_info *, int ports);
 };
 
-static void inline s3c2410_usb_report_oc(struct s3c2410_hcd_info *info, int ports)
+static inline void s3c2410_usb_report_oc(struct s3c2410_hcd_info *info, int ports)
 {
 	if (info->report_oc != NULL) {
 		(info->report_oc)(info, ports);
-- 
1.7.7.6
