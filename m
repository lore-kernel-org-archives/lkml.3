Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab3KBNtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 09:49:43 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35690 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab3KBNth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 09:49:37 -0400
From: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
To: davem@davemloft.net, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, IvDoorn@gmail.com, sbhatewara@vmware.com,
        samuel@sortiz.org, chas@cmf.nrl.navy.mil, roland@kernel.org,
        isdn@linux-pingi.de, jcliburn@gmail.com, benve@cisco.com,
        ssujith@cisco.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, shahed.shaikh@qlogic.com, joe@perches.com,
        apw@canonical.com
Cc: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
Subject: [PATCH net-next 13/13] scripts/checkpatch.pl: Add dev_kfree_skb*(NULL) check to checkpatch
Date: Sat,  2 Nov 2013 19:17:54 +0530
Message-Id: <1383400074-30555-14-git-send-email-govindarajulu90@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1383400074-30555-1-git-send-email-govindarajulu90@gmail.com>
References: <1383400074-30555-1-git-send-email-govindarajulu90@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 66cad50..e651b8a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3719,7 +3719,7 @@ sub process {
 # check for needless "if (<foo>) fn(<foo>)" uses
 		if ($prevline =~ /\bif\s*\(\s*($Lval)\s*\)/) {
 			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
-			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
+			if ($line =~ /\b(kfree|dev_kfree_skb|dev_kfree_skb_any|dev_kfree_skb_irq|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
 				WARN('NEEDLESS_IF',
 				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
 			}
-- 
1.8.4.2

