Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbaCUAD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:03:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760208AbaCUAD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Art -kwaak- van Breemen <ard@telegraafnet.nl>,
        Hans Schillstrom <hans@schillstrom.com>,
        Ansis Atteka <aatteka@nicira.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 018/149] ipv6: ipv6_find_hdr restore prev functionality
Date: Thu, 20 Mar 2014 17:03:01 -0700
Message-Id: <20140321000437.581074321@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Schillstrom <hans@schillstrom.com>

[ Upstream commit accfe0e356327da5bd53da8852b93fc22de9b5fc ]

The commit 9195bb8e381d81d5a315f911904cdf0cfcc919b8 ("ipv6: improve
ipv6_find_hdr() to skip empty routing headers") broke ipv6_find_hdr().

When a target is specified like IPPROTO_ICMPV6 ipv6_find_hdr()
returns -ENOENT when it's found, not the header as expected.

A part of IPVS is broken and possible also nft_exthdr_eval().
When target is -1 which it is most cases, it works.

This patch exits the do while loop if the specific header is found
so the nexthdr could be returned as expected.

Reported-by: Art -kwaak- van Breemen <ard@telegraafnet.nl>
Signed-off-by: Hans Schillstrom <hans@schillstrom.com>
CC:Ansis Atteka <aatteka@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -212,7 +212,7 @@ int ipv6_find_hdr(const struct sk_buff *
 		found = (nexthdr == target);
 
 		if ((!ipv6_ext_hdr(nexthdr)) || nexthdr == NEXTHDR_NONE) {
-			if (target < 0)
+			if (target < 0 || found)
 				break;
 			return -ENOENT;
 		}


