Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3K2ViR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 16:38:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54928 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3K2ViO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 16:38:14 -0500
Date: Fri, 29 Nov 2013 16:38:13 -0500 (EST)
Message-Id: <20131129.163813.2060324714200934714.davem@davemloft.net>
To: hannes@stressinduktion.org
Cc: eric.dumazet@gmail.com, jongman.heo@samsung.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] inet: fix possible seqlock deadlocks
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131128180914.GA24171@order.stressinduktion.org>
References: <1385659390.5352.20.camel@edumazet-glaptop2.roam.corp.google.com>
	<1385661082.5352.34.camel@edumazet-glaptop2.roam.corp.google.com>
	<20131128180914.GA24171@order.stressinduktion.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 29 Nov 2013 13:38:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Date: Thu, 28 Nov 2013 19:09:14 +0100

> On Thu, Nov 28, 2013 at 09:51:22AM -0800, Eric Dumazet wrote:
>> From: Eric Dumazet <edumazet@google.com>
>> 
>> In commit c9e9042994d3 ("ipv4: fix possible seqlock deadlock") I left
>> another places where IP_INC_STATS_BH() were improperly used.
>> 
>> udp_sendmsg(), ping_v4_sendmsg() and tcp_v4_connect() are called from
>> process context, not from softirq context.
>> 
>> This was detected by lockdep seqlock support.
>> 
>> Reported-by: jongman heo <jongman.heo@samsung.com>
>> Fixes: 584bdf8cbdf6 ("[IPV4]: Fix "ipOutNoRoutes" counter error for TCP and UDP")
>> Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> 
> Just got home after getting distracted with other things today and the work is
> already done. Thanks, Eric! ;)
> 
> Exactly the spots I noticed this morning, so
> 
> Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>

Applied and queued up for -stable.
