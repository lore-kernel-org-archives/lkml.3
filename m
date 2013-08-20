Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab3HTWoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 18:44:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3HTWoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 18:44:44 -0400
Date: Tue, 20 Aug 2013 15:44:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.10.9
Message-ID: <20130820224443.GB25146@kroah.com>
References: <20130820224426.GA25146@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820224426.GA25146@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 1a216126..4b31d623 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 10
-SUBLEVEL = 8
+SUBLEVEL = 9
 EXTRAVERSION =
 NAME = TOSSUG Baby Fish
 
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index ba6e55d1..1076fe16 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -789,10 +789,6 @@ static int ctrl_dumpfamily(struct sk_buff *skb, struct netlink_callback *cb)
 	struct net *net = sock_net(skb->sk);
 	int chains_to_skip = cb->args[0];
 	int fams_to_skip = cb->args[1];
-	bool need_locking = chains_to_skip || fams_to_skip;
-
-	if (need_locking)
-		genl_lock();
 
 	for (i = chains_to_skip; i < GENL_FAM_TAB_SIZE; i++) {
 		n = 0;
@@ -814,9 +810,6 @@ errout:
 	cb->args[0] = i;
 	cb->args[1] = n;
 
-	if (need_locking)
-		genl_unlock();
-
 	return skb->len;
 }
 
