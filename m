Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933621Ab3CLWdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:33:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab3CLWck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steven Noonan <steven@uplinklabs.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 006/100] xenbus: fix compile failure on ARM with Xen enabled
Date: Tue, 12 Mar 2013 15:30:51 -0700
Message-Id: <20130312223123.598183454@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Noonan <steven@uplinklabs.net>

commit 45e27161c62216c163880d7aed751cb55a65c8e9 upstream.

Adding an include of linux/mm.h resolves this:
	drivers/xen/xenbus/xenbus_client.c: In function ‘xenbus_map_ring_valloc_hvm’:
	drivers/xen/xenbus/xenbus_client.c:532:66: error: implicit declaration of function ‘page_to_section’ [-Werror=implicit-function-declaration]

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xenbus/xenbus_client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -30,6 +30,7 @@
  * IN THE SOFTWARE.
  */
 
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>


