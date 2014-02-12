Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaBLTyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:54:47 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:33407 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaBLTyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:54:46 -0500
Date: Wed, 12 Feb 2014 11:54:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: gregkh@linux.com, Larry.Finger@lwfinger.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Additional item for rtl8188eu TODO list
Message-ID: <20140212195432.GA32233@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021219-9332-0000-0000-000003159BEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

The rtw_recv_indicatepkt() function in the file named
drivers/staging/rtl8188eu/os_dep/recv_linux.c has this strange code:

	rcu_read_lock();
	rcu_dereference(padapter->pnetdev->rx_handler_data);
	rcu_read_unlock();

This code has no effect.  Normally, you would assign the result of
rcu_dereference() to some variable, but it is not clear from the
code what variable that would be.  Therefore, this patch applies to
the TODO file instead of the code itself.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/drivers/staging/rtl8188eu/TODO b/drivers/staging/rtl8188eu/TODO
index f7f389c40e71..b574b235b340 100644
--- a/drivers/staging/rtl8188eu/TODO
+++ b/drivers/staging/rtl8188eu/TODO
@@ -9,6 +9,11 @@ TODO:
 - merge Realtek's bugfixes and new features into the driver
 - switch to use LIB80211
 - switch to use MAC80211
+- figure out what to do with this code in rtw_recv_indicatepkt():
+	rcu_read_lock();
+	rcu_dereference(padapter->pnetdev->rx_handler_data);
+	rcu_read_unlock();
+  Perhaps delete it, perhaps assign to some local variable.
 
 Please send any patches to Greg Kroah-Hartman <gregkh@linux.com>,
 and Larry Finger <Larry.Finger@lwfinger.net>.

