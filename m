Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab3GZU6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:58:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760049Ab3GZU6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:58:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/45] net: Swap ver and type in pppoe_hdr
Date: Fri, 26 Jul 2013 13:57:39 -0700
Message-Id: <20130726205657.008520123@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205654.896050165@linuxfoundation.org>
References: <20130726205654.896050165@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changli Gao <xiaosuo@gmail.com>

[ Upstream commit b1a5a34bd0b8767ea689e68f8ea513e9710b671e ]

Ver and type in pppoe_hdr should be swapped as defined by RFC2516
section-4.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/if_pppox.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/if_pppox.h
+++ b/include/linux/if_pppox.h
@@ -127,11 +127,11 @@ struct pppoe_tag {
 
 struct pppoe_hdr {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-	__u8 ver : 4;
 	__u8 type : 4;
+	__u8 ver : 4;
 #elif defined(__BIG_ENDIAN_BITFIELD)
-	__u8 type : 4;
 	__u8 ver : 4;
+	__u8 type : 4;
 #else
 #error	"Please fix <asm/byteorder.h>"
 #endif


