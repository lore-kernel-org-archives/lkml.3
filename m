Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422847Ab3LFWgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:36:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161058Ab3LFVwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 35/83] ipv6: Fix inet6_init() cleanup order
Date: Fri,  6 Dec 2013 13:51:25 -0800
Message-Id: <20131206214643.313825871@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

Commit 6d0bfe22611602f36617bc7aa2ffa1bbb2f54c67
	net: ipv6: Add IPv6 support to the ping socket

introduced a change in the cleanup logic of inet6_init and
has a bug in that ipv6_packet_cleanup() may not be called.
Fix the cleanup ordering.

CC: Hannes Frederic Sowa <hannes@stressinduktion.org>
CC: Lorenzo Colitti <lorenzo@google.com>
CC: Fabio Estevam <fabio.estevam@freescale.com>
Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/af_inet6.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -965,10 +965,10 @@ out:
 
 #ifdef CONFIG_SYSCTL
 sysctl_fail:
-	ipv6_packet_cleanup();
+	pingv6_exit();
 #endif
 pingv6_fail:
-	pingv6_exit();
+	ipv6_packet_cleanup();
 ipv6_packet_fail:
 	tcpv6_exit();
 tcpv6_fail:


