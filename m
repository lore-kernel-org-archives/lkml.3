Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbbA1Bce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:32:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759627AbbA1B2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.18 53/61] netfilter: nfnetlink: relax strict multicast group check from netlink_bind
Date: Tue, 27 Jan 2015 17:27:05 -0800
Message-Id: <20150128012642.802820312@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 62924af247e95de7041a6d6f2d06cdd05152e2dc upstream.

Relax the checking that was introduced in 97840cb ("netfilter:
nfnetlink: fix insufficient validation in nfnetlink_bind") when the
subscription bitmask is used. Existing userspace code code may request
to listen to all of the existing netlink groups by setting an all to one
subscription group bitmask. Netlink already validates subscription via
setsockopt() for us.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nfnetlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -470,7 +470,7 @@ static int nfnetlink_bind(int group)
 	int type;
 
 	if (group <= NFNLGRP_NONE || group > NFNLGRP_MAX)
-		return -EINVAL;
+		return 0;
 
 	type = nfnl_group2type[group];
 


