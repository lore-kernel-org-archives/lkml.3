Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496AbaHQLnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 07:43:47 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:51071 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaHQLnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 07:43:46 -0400
Date: Sun, 17 Aug 2014 14:43:37 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net, oat.elena@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] rtl8188eu: Replace rcu_dereference() with
 rcu_access_pointer()
Message-ID: <20140817114336.GA24984@ada>
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
 drivers/staging/rtl8188eu/core/rtw_mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_mlme.c b/drivers/staging/rtl8188eu/core/rtw_mlme.c
index 155282e..8643003 100644
--- a/drivers/staging/rtl8188eu/core/rtw_mlme.c
+++ b/drivers/staging/rtl8188eu/core/rtw_mlme.c
@@ -1544,7 +1544,7 @@ void rtw_dynamic_check_timer_handlder(struct adapter *adapter)
 
 	rcu_read_lock();
 
-	if (rcu_dereference(adapter->pnetdev->rx_handler_data) &&
+	if (rcu_access_pointer(adapter->pnetdev->rx_handler_data) &&
 	    (check_fwstate(pmlmepriv, WIFI_STATION_STATE|WIFI_ADHOC_STATE) == true)) {
 		/*  expire NAT2.5 entry */
 		nat25_db_expire(adapter);
-- 
1.9.1

