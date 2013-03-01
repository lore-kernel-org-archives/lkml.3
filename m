Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab3CANPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:15:24 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:39608 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3CANPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:15:23 -0500
From: Steven Noonan <steven@uplinklabs.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH] xenbus: fix compile failure on ARM with Xen enabled
Date: Fri,  1 Mar 2013 05:14:59 -0800
Message-Id: <1362143699-4526-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding an include of linux/mm.h resolves this:
	drivers/xen/xenbus/xenbus_client.c: In function ‘xenbus_map_ring_valloc_hvm’:
	drivers/xen/xenbus/xenbus_client.c:532:66: error: implicit declaration of function ‘page_to_section’ [-Werror=implicit-function-declaration]

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 drivers/xen/xenbus/xenbus_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index bcf3ba4..61786be 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -30,6 +30,7 @@
  * IN THE SOFTWARE.
  */
 
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
-- 
1.8.1.2

