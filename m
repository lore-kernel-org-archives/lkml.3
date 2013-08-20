Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab3HTSlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:41:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36403 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3HTSlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:41:01 -0400
Date: Tue, 20 Aug 2013 11:41:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.0.93
Message-ID: <20130820184100.GB25943@kroah.com>
References: <20130820184050.GA25943@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820184050.GA25943@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index a846aa89..369ce146 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 0
-SUBLEVEL = 92
+SUBLEVEL = 93
 EXTRAVERSION =
 NAME = Sneaky Weasel
 
diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 409dd405..874f8ffb 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -700,10 +700,6 @@ static int ctrl_dumpfamily(struct sk_buff *skb, struct netlink_callback *cb)
 	struct net *net = sock_net(skb->sk);
 	int chains_to_skip = cb->args[0];
 	int fams_to_skip = cb->args[1];
-	bool need_locking = chains_to_skip || fams_to_skip;
-
-	if (need_locking)
-		genl_lock();
 
 	for (i = chains_to_skip; i < GENL_FAM_TAB_SIZE; i++) {
 		n = 0;
@@ -725,9 +721,6 @@ errout:
 	cb->args[0] = i;
 	cb->args[1] = n;
 
-	if (need_locking)
-		genl_unlock();
-
 	return skb->len;
 }
 
