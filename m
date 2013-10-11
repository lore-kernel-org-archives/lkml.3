Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab3JKUO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:14:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334Ab3JKTlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:41:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>
Subject: [ 009/135] ipv6/exthdrs: accept tlv which includes only padding
Date: Fri, 11 Oct 2013 12:38:10 -0700
Message-Id: <20131011193946.232182366@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit 8112b1fe071be01a28a774ed55909e6f4b29712d ]

In rfc4942 and rfc2460 I cannot find anything which would implicate to
drop packets which have only padding in tlv.

Current behaviour breaks TAHI Test v6LC.1.2.6.

Problem was intruduced in:
9b905fe6843 "ipv6/exthdrs: strict Pad1 and PadN check"

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -162,12 +162,6 @@ static bool ip6_parse_tlv(const struct t
 		off += optlen;
 		len -= optlen;
 	}
-	/* This case will not be caught by above check since its padding
-	 * length is smaller than 7:
-	 * 1 byte NH + 1 byte Length + 6 bytes Padding
-	 */
-	if ((padlen == 6) && ((off - skb_network_header_len(skb)) == 8))
-		goto bad;
 
 	if (len == 0)
 		return true;


