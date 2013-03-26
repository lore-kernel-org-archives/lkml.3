Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab3CZXud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:50:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3CZWni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 04/98] bridge: reserve space for IFLA_BRPORT_FAST_LEAVE
Date: Tue, 26 Mar 2013 15:41:53 -0700
Message-Id: <20130326224242.895877869@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: stephen hemminger <stephen@networkplumber.org>

[ Upstream commit 3da889b616164bde76a37350cf28e0d17a94e979 ]

The bridge multicast fast leave feature was added sufficient space
was not reserved in the netlink message. This means the flag may be
lost in netlink events and results of queries.

Found by observation while looking up some netlink stuff for discussion with Vlad.
Problem introduced by commit c2d3babfafbb9f6629cfb47139758e59a5eb0d80
Author: David S. Miller <davem@davemloft.net>
Date:   Wed Dec 5 16:24:45 2012 -0500

    bridge: implement multicast fast leave

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_netlink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -28,6 +28,7 @@ static inline size_t br_port_info_size(v
 		+ nla_total_size(1)	/* IFLA_BRPORT_MODE */
 		+ nla_total_size(1)	/* IFLA_BRPORT_GUARD */
 		+ nla_total_size(1)	/* IFLA_BRPORT_PROTECT */
+		+ nla_total_size(1)	/* IFLA_BRPORT_FAST_LEAVE */
 		+ 0;
 }
 


