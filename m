Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197Ab3EIW44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:56:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46063 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab3EIWc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 25/73] netfilter: ip6t_NPT: Fix translation for non-multiple of 32 prefix lengths
Date: Thu,  9 May 2013 15:31:48 -0700
Message-Id: <20130509222800.716039455@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <mschiffer@universe-factory.net>

commit 906b1c394d0906a154fbdc904ca506bceb515756 upstream.

The bitmask used for the prefix mangling was being calculated
incorrectly, leading to the wrong part of the address being replaced
when the prefix length wasn't a multiple of 32.

Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/netfilter/ip6t_NPT.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/netfilter/ip6t_NPT.c
+++ b/net/ipv6/netfilter/ip6t_NPT.c
@@ -57,7 +57,7 @@ static bool ip6t_npt_map_pfx(const struc
 		if (pfx_len - i >= 32)
 			mask = 0;
 		else
-			mask = htonl(~((1 << (pfx_len - i)) - 1));
+			mask = htonl((1 << (i - pfx_len + 32)) - 1);
 
 		idx = i / 32;
 		addr->s6_addr32[idx] &= mask;


