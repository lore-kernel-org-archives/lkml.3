Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab3BZX7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:59:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933276Ab3BZX6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: [ 10/53] xen/netback: check correct frag when looking for head frag
Date: Tue, 26 Feb 2013 15:57:39 -0800
Message-Id: <20130226235620.921946936@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Campbell <ian.campbell@citrix.com>

When I backported 7d5145d8eb2b "xen/netback: don't leak pages on failure in
xen_netbk_tx_check_gop" to 3.0 (where it became f0457844e605) I somehow picked
up an extraneous hunk breaking this.

Reported-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/xen-netback/netback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -990,7 +990,7 @@ static int xen_netbk_tx_check_gop(struct
 		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_ERROR);
 
 	/* Skip first skb fragment if it is on same page as header fragment. */
-	start = ((unsigned long)shinfo->frags[i].page == pending_idx);
+	start = ((unsigned long)shinfo->frags[0].page == pending_idx);
 
 	for (i = start; i < nr_frags; i++) {
 		int j, newerr;


