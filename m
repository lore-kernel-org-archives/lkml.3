Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbaDYQTl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:19:41 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:49567 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbaDYQTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:19:35 -0400
From: Roman Gushchin <klamm@yandex-team.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "tkhai@yandex.ru" <tkhai@yandex.ru>
In-Reply-To: <20140425151116.GJ11096@twins.programming.kicks-ass.net>
References: <36851398363372@webcorp2g.yandex-team.ru>
	 <20140424185858.GB26782@laptop.programming.kicks-ass.net>
	 <17051398423889@webcorp2e.yandex-team.ru>
	 <20140425131620.GB11096@twins.programming.kicks-ass.net>
	 <34791398438136@webcorp2g.yandex-team.ru> <20140425151116.GJ11096@twins.programming.kicks-ass.net>
Subject: Re: Real-time scheduling policies and hyper-threading
MIME-Version: 1.0
Message-Id: <7611398442772@webcorp1g.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Fri, 25 Apr 2014 20:19:32 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25.04.2014, 19:11, "Peter Zijlstra" <peterz@infradead.org>:
> On Fri, Apr 25, 2014 at 07:02:16PM +0400, Roman Gushchin wrote:
>
>> šHm. What I really want (and try to implement), is
>> š"work as if ht is disabled if there are free physical cores, start using ht siblings otherwise".
>
> At which point I have to ask, what about the rest of the topology?

My prototype works as follows: all physical cores on every numa node 
are linked into circular list. When I have to select a cpu, I traverse the list 
and search for a free core. If there is one, I select them. Otherwise, I jump to the
other node and search there too. It's better to save symmetry here: when I start
with local core number 3, it's reasonable to start with remote core number 3 too.
Also, there is a "node balancing" logic, that causes me to start searching 
with remote node, if a big imbalance is detected. It helps to work good under
small load (<8 requests). When there are no free cores, I use the similar logic
to find a free thread.

Now I'm trying to make this algorithm more general and scalable. It will be
great to use the current O(1) cpupri approach on each cpu topology level somehow,
but I have no complete solution yet.

> Also, how is a task to know if its the 16th or 17th and thus should
> expect worse latency?

No way.

>> šIt's a 32-thread processor with 16 physical cores.
>
> No NUMA? I'm not aware of single node systems with 16 cores.

Of course, 2 physical processors with 8 cores each :)
Sorry.

Thanks,
Roman
