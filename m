Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaB0MPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:15:49 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:34491 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaB0MPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:15:47 -0500
Date: Thu, 27 Feb 2014 17:43:33 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, josh@joshtriplett.org
Subject: [PATCH 31/46] kernel: Mark function as static in kernel/module.c
Message-ID: <04556818c35332bc933e144163767cd8bf564e0a.1393493277.git.rashika.kheria@gmail.com>
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

Mark function as static in kernel/module.c because it is not used
outside this file.

This eliminates the following warning in kernel/module.c:
kernel/module.c:1719:6: warning: no previous prototype for ‘set_page_attributes’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/module.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index d24fcf2..93239aa 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1716,7 +1716,8 @@ static int __unlink_module(void *_mod)
  * LKM RO/NX protection: protect module's text/ro-data
  * from modification and any data from execution.
  */
-void set_page_attributes(void *start, void *end, int (*set)(unsigned long start, int num_pages))
+static void set_page_attributes(void *start, void *end,
+				int (*set)(unsigned long start, int num_pages))
 {
 	unsigned long begin_pfn = PFN_DOWN((unsigned long)start);
 	unsigned long end_pfn = PFN_DOWN((unsigned long)end);
-- 
1.7.9.5

