Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3LOTXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 14:23:20 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37569 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3LOTXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 14:23:18 -0500
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
        josh@joshtriplett.org
Subject: =?UTF-8?q?=5BPATCH=20v2=5D=20drivers=3A=20memstick=3A=20Mark=20function=20memstick=5Fdebug=5Fget=5Ftpc=5Fname=28=29=20as=20static=20in=20r592=2Ec?=
Date: Mon, 16 Dec 2013 00:53:02 +0530
Message-Id: <1387135382-26920-1-git-send-email-rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20131214130717.GA8361@rashika>
References: <20131214130717.GA8361@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch marks the function memstick_debug_get_tpc_name() as static in
host/r592.c because it is not used outside this file. It also removes the
EXPORT_SYMBOL because the function is not used anywhere else in the
kernel.

Thus, it also eliminates the following warning in host/r592.c:
drivers/memstick/host/r592.c:50:13: warning: no previous prototype for ‘memstick_debug_get_tpc_name’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 drivers/memstick/host/r592.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index 31727bf..d03aacb 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -47,12 +47,10 @@ static const char *tpc_names[] = {
  * memstick_debug_get_tpc_name - debug helper that returns string for
  * a TPC number
  */
-const char *memstick_debug_get_tpc_name(int tpc)
+static const char *memstick_debug_get_tpc_name(int tpc)
 {
 	return tpc_names[tpc-1];
 }
-EXPORT_SYMBOL(memstick_debug_get_tpc_name);
-
 
 /* Read a register*/
 static inline u32 r592_read_reg(struct r592_device *dev, int address)
-- 
1.7.9.5

