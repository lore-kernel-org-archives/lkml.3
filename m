Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaHKK1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:27:30 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:25459
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbaHKK13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:27:29 -0400
X-IronPort-AV: E=Sophos;i="5.01,840,1400018400"; 
   d="scan'208";a="74499983"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/coccinelle/free/ifnullfree.cocci: simplify and extend to of_node_put
Date: Mon, 11 Aug 2014 12:24:13 +0200
Message-Id: <1407752653-16883-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Three changes:

* Don't remove and add function calls in the patch case
* Add of_node_put as a considered function
* Add a missing position variable on usb_free_urb

The need for the last change was spotted by SF Markus Elfring.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 scripts/coccinelle/free/ifnullfree.cocci |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/scripts/coccinelle/free/ifnullfree.cocci b/scripts/coccinelle/free/ifnullfree.cocci
index a42d70b..31be901 100644
--- a/scripts/coccinelle/free/ifnullfree.cocci
+++ b/scripts/coccinelle/free/ifnullfree.cocci
@@ -18,17 +18,15 @@ expression E;
 @@
 - if (E)
 (
--	kfree(E);
-+ kfree(E);
+	kfree(E);
 |
--	debugfs_remove(E);
-+ debugfs_remove(E);
+	debugfs_remove(E);
 |
--	debugfs_remove_recursive(E);
-+ debugfs_remove_recursive(E);
+	debugfs_remove_recursive(E);
 |
--	usb_free_urb(E);
-+ usb_free_urb(E);
+	usb_free_urb(E);
+|
+	of_node_put(E);
 )
 
 @r depends on context || report || org @
@@ -37,7 +35,8 @@ position p;
 @@
 
 * if (E)
-*	\(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb\)(E);
+*  \(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb@p\|
+*    of_node_put@p\)(E);
 
 @script:python depends on org@
 p << r.p;

