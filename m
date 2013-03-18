Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854Ab3CRVqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:46:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab3CRVHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 73/75] 6lowpan: Fix endianness issue in is_addr_link_local().
Date: Mon, 18 Mar 2013 14:07:36 -0700
Message-Id: <20130318210515.533117360@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

[ Upstream commit 9026c4927254f5bea695cc3ef2e255280e6a3011 ]

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/6lowpan.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ieee802154/6lowpan.h
+++ b/net/ieee802154/6lowpan.h
@@ -84,7 +84,7 @@
 	(memcmp(addr1, addr2, length >> 3) == 0)
 
 /* local link, i.e. FE80::/10 */
-#define is_addr_link_local(a) (((a)->s6_addr16[0]) == 0x80FE)
+#define is_addr_link_local(a) (((a)->s6_addr16[0]) == htons(0xFE80))
 
 /*
  * check whether we can compress the IID to 16 bits,


