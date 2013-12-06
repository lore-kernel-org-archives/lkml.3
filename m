Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422822Ab3LFWb6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:31:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759158Ab3LFVwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 50/83] xen-netback: include definition of csum_ipv6_magic
Date: Fri,  6 Dec 2013 13:51:40 -0800
Message-Id: <20131206214644.714645560@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Whitcroft <apw@canonical.com>

[ Upstream commit ae5e8127b712313ec1b99356019ce9226fea8b88 ]

We are now using csum_ipv6_magic, include the appropriate header.
Avoids the following error:

    drivers/net/xen-netback/netback.c:1313:4: error: implicit declaration of function 'csum_ipv6_magic' [-Werror=implicit-function-declaration]
        tcph->check = ~csum_ipv6_magic(&ipv6h->saddr,

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/netback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -39,6 +39,7 @@
 #include <linux/udp.h>
 
 #include <net/tcp.h>
+#include <net/ip6_checksum.h>
 
 #include <xen/xen.h>
 #include <xen/events.h>


