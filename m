Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608Ab3JPO1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:27:07 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:41527 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934536Ab3JPO1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:27:05 -0400
Date: Wed, 16 Oct 2013 14:27:03 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/6] net: ip4_datagram_connect: Use correct form of
 statistics update
In-Reply-To: <20131016092601.GB23440@gmail.com>
Message-ID: <00000141c1a9a88d-2fe8384a-435c-4c40-bafd-c3fc04960783-000000@email.amazonses.com>
References: <20131015174722.615394057@linux.com> <20131015174745.197380080@linux.com> <20131016083545.GP10651@twins.programming.kicks-ass.net> <1381914869.2045.112.camel@edumazet-glaptop.roam.corp.google.com> <20131016092601.GB23440@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same issue in ipv6 code.


Subject: net: Fix statistics update in ip6

ipv6 does the same as ipv4. IP6_INC_STATS must be used outside
of BH sections.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/net/ipv6/ip6_output.c
===================================================================
--- linux.orig/net/ipv6/ip6_output.c	2013-10-10 11:01:01.119771564 -0500
+++ linux/net/ipv6/ip6_output.c	2013-10-16 08:48:19.474562100 -0500
@@ -909,7 +909,7 @@ static int ip6_dst_lookup_tail(struct so

 out_err_release:
 	if (err == -ENETUNREACH)
-		IP6_INC_STATS_BH(net, NULL, IPSTATS_MIB_OUTNOROUTES);
+		IP6_INC_STATS(net, NULL, IPSTATS_MIB_OUTNOROUTES);
 	dst_release(*dst);
 	*dst = NULL;
 	return err;
