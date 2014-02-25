Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaBYUua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:50:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57732 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbaBYUu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:50:29 -0500
Date: Tue, 25 Feb 2014 15:50:27 -0500 (EST)
Message-Id: <20140225.155027.608005295265342140.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org, rientjes@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: use __GFP_NORETRY for high order allocations
From: David Miller <davem@davemloft.net>
In-Reply-To: <87y51me9lr.fsf@xmission.com>
References: <1391712162.10160.8.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140206.222932.292588043950970246.davem@davemloft.net>
	<87y51me9lr.fsf@xmission.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Feb 2014 12:50:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 07 Feb 2014 16:22:56 -0800

> David Miller <davem@davemloft.net> writes:
> 
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Thu, 06 Feb 2014 10:42:42 -0800
>>
>>> From: Eric Dumazet <edumazet@google.com>
>>> 
>>> sock_alloc_send_pskb() & sk_page_frag_refill()
>>> have a loop trying high order allocations to prepare
>>> skb with low number of fragments as this increases performance.
>>> 
>>> Problem is that under memory pressure/fragmentation, this can
>>> trigger OOM while the intent was only to try the high order
>>> allocations, then fallback to order-0 allocations.
>>> 
>>> We had various reports from unexpected regressions.
>>> 
>>> According to David, setting __GFP_NORETRY should be fine,
>>> as the asynchronous compaction is still enabled, and this
>>> will prevent OOM from kicking as in :
>>  ...
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>> Acked-by: David Rientjes <rientjes@google.com>
>>
>> Applied, do we want this for -stable?
> 
> The first hunk goes back to 3.12 and the second hunk goes back to 3.8.
> 
> I think so.    The change is safe and this class of problem can cause an
> external attack to trigger an OOM on your box, by controlling the packet
> flow.

Great, I'm working integrating this into my -stable queue right now.
