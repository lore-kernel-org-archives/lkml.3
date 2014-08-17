Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaHQNj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 09:39:26 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:39626 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaHQNjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 09:39:25 -0400
Date: Sun, 17 Aug 2014 16:39:16 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        navin.patidar@gmail.com, davem@davemloft.net, jasowang@redhat.com,
        stsp@users.sourceforge.net, dborkman@redhat.com,
        Jes.Sorensen@redhat.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] os_dep: Replace rcu_dereference() with rcu_access_pointer()
Message-ID: <20140817133916.GA12655@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "rcu_dereference()" call is used directly in a condition.
Since its return value is never dereferenced it is recommended to use
"rcu_access_pointer()" instead of "rcu_dereference()".
Therefore, this patch makes the replacement.

The following Coccinelle semantic patch was used:
@@
@@

(
 if(
 (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
  ...+>)) {...}
|
 while(
 (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
  ...+>)) {...}
)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/staging/rtl8188eu/os_dep/os_intfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 0e0c32d..4bb76e5 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -1010,7 +1010,7 @@ void netdev_br_init(struct net_device *netdev)
 
 	rcu_read_lock();
 
-	if (rcu_dereference(adapter->pnetdev->rx_handler_data)) {
+	if (rcu_access_pointer(adapter->pnetdev->rx_handler_data)) {
 		struct net_device *br_netdev;
 		struct net *devnet = NULL;
 
-- 
1.9.1

