Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab3BVUO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:14:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46855 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3BVUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:14:23 -0500
Date: Fri, 22 Feb 2013 15:14:20 -0500 (EST)
Message-Id: <20130222.151420.1087260069127274940.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH] net: fix possible deadlock in sum_frag_mem_limit
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361555015.3683.14.camel@edumazet-glaptop>
References: <20130222171343.GB27619@redhat.com>
	<1361555015.3683.14.camel@edumazet-glaptop>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 22 Feb 2013 12:14:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 22 Feb 2013 09:43:35 -0800

> From: Eric Dumazet <edumazet@google.com>
> 
> Dave Jones reported a lockdep splat occurring in IP defrag code.
> 
> commit 6d7b857d541ecd1d (net: use lib/percpu_counter API for
> fragmentation mem accounting) added a possible deadlock.
> 
> Because percpu_counter_sum_positive() needs to acquire
> a lock that can be used from softirq, we need to disable BH
> in sum_frag_mem_limit()
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>

Applied.
