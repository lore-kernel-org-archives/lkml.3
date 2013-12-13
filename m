Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3LMGve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 01:51:34 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:47229 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3LMGvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 01:51:31 -0500
Date: Fri, 13 Dec 2013 12:21:20 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: josh@joshtriplett.org, Robin Holt <robinmholt@gmail.com>,
        Cliff Whickman <cpw@sgi.com>
Subject: [PATCH 2/5] drivers: misc: Mark functions as static in xp_main.c
Message-ID: <49ece621a2dbbdfad71e81c3185d7e8a32c52823.1386915618.git.rashika.kheria@gmail.com>
References: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40521f78bafae3cc4e796c540d3c497d79eeb63e.1386915618.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function xp_init() and xp_exit() as static in
sgi-xp/xp_main.c because they are not used outside this file.

Thus, it also eliminates the following warnings in sgi-xp/xp_main.c:
drivers/misc/sgi-xp/xp_main.c:249:1: warning: no previous prototype for ‘xp_init’ [-Wmissing-prototypes]
drivers/misc/sgi-xp/xp_main.c:274:1: warning: no previous prototype for ‘xp_exit’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/misc/sgi-xp/xp_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/sgi-xp/xp_main.c b/drivers/misc/sgi-xp/xp_main.c
index 01be66d..df14c70 100644
--- a/drivers/misc/sgi-xp/xp_main.c
+++ b/drivers/misc/sgi-xp/xp_main.c
@@ -245,7 +245,7 @@ xpc_disconnect(int ch_number)
 }
 EXPORT_SYMBOL_GPL(xpc_disconnect);
 
-int __init
+static int __init
 xp_init(void)
 {
 	enum xp_retval ret;
@@ -270,7 +270,7 @@ xp_init(void)
 
 module_init(xp_init);
 
-void __exit
+static void __exit
 xp_exit(void)
 {
 	if (is_shub())
-- 
1.7.9.5

