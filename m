Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab3CNKhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51860 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab3CNKhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Noonan <steven@uplinklabs.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 33/88] xenbus: fix compile failure on ARM with Xen enabled
Date: Thu, 14 Mar 2013 10:35:26 +0000
Message-Id: <1363257381-15900-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Noonan <steven@uplinklabs.net>

commit 45e27161c62216c163880d7aed751cb55a65c8e9 upstream.

Adding an include of linux/mm.h resolves this:
	drivers/xen/xenbus/xenbus_client.c: In function ‘xenbus_map_ring_valloc_hvm’:
	drivers/xen/xenbus/xenbus_client.c:532:66: error: implicit declaration of function ‘page_to_section’ [-Werror=implicit-function-declaration]

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/xenbus/xenbus_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index b3e146e..1a77f2b 100644
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

