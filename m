Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbaIKNLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:11:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189AbaIKNEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:04:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Malcolm Priestley" <tvboxspy@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.109561936@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 020/131] staging: vt6655: Fix disassociated messages
 every 10 seconds
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 4aa0abed3a2a11b7d71ad560c1a3e7631c5a31cd upstream.

byReAssocCount is incremented every second resulting in
disassociated message being send every 10 seconds whether
connection or not.

byReAssocCount should only advance while eCommandState
is in WLAN_ASSOCIATE_WAIT

Change existing scope to if condition.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6655/bssdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -1083,7 +1083,7 @@ start:
         pDevice->byERPFlag &= ~(WLAN_SET_ERP_USE_PROTECTION(1));
     }
 
-{
+    if (pDevice->eCommandState == WLAN_ASSOCIATE_WAIT) {
        pDevice->byReAssocCount++;
    if((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != true)) {  //10 sec timeout
                      printk("Re-association timeout!!!\n");

