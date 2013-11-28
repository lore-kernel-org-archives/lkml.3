Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153Ab3K1SJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 13:09:18 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:44724 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab3K1SJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 13:09:16 -0500
Date: Thu, 28 Nov 2013 19:09:14 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: jongman.heo@samsung.com, David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] inet: fix possible seqlock deadlocks
Message-ID: <20131128180914.GA24171@order.stressinduktion.org>
Mail-Followup-To: Eric Dumazet <eric.dumazet@gmail.com>,
	jongman.heo@samsung.com, David Miller <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <13025162.118881385612276530.JavaMail.weblogic@epv6ml01> <1385659390.5352.20.camel@edumazet-glaptop2.roam.corp.google.com> <1385661082.5352.34.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385661082.5352.34.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 09:51:22AM -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> In commit c9e9042994d3 ("ipv4: fix possible seqlock deadlock") I left
> another places where IP_INC_STATS_BH() were improperly used.
> 
> udp_sendmsg(), ping_v4_sendmsg() and tcp_v4_connect() are called from
> process context, not from softirq context.
> 
> This was detected by lockdep seqlock support.
> 
> Reported-by: jongman heo <jongman.heo@samsung.com>
> Fixes: 584bdf8cbdf6 ("[IPV4]: Fix "ipOutNoRoutes" counter error for TCP and UDP")
> Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>

Just got home after getting distracted with other things today and the work is
already done. Thanks, Eric! ;)

Exactly the spots I noticed this morning, so

Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Should we do something about the naming? I find it rather dangerous because
they look like the _bh lock postfixes but act exactly in the opposite?

Greetings,

  Hannes

