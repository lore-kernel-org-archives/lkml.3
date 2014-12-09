Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaLIXNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 18:13:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:21798 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbaLIXNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 18:13:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,548,1413270000"; 
   d="scan'208";a="645118485"
Message-ID: <5487820C.4030801@intel.com>
Date: Tue, 09 Dec 2014 15:13:16 -0800
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
CC: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] fix suspicious rcu_dereference_check in net/sched/sch_fq_codel.c
References: <58905.1418159750@turing-police.cc.vt.edu> <1418161372.27198.11.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1418161372.27198.11.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2014 01:42 PM, Eric Dumazet wrote:
> On Tue, 2014-12-09 at 16:15 -0500, Valdis Kletnieks wrote:
>> commit 46e5da40ae (net: qdisc: use rcu prefix and silence
>>  sparse warnings) triggers a spurious warning:
>>
>> net/sched/sch_fq_codel.c:97 suspicious rcu_dereference_check() usage!
>>
>> The code should be using the _bh variant of rcu_dereference.
>>
>> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
>> ---
>>  net/sched/sch_fq_codel.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Acked-by: Eric Dumazet <edumazet@google.com>
> 
> Thanks !
> 
> 

Great thanks for finding/fixing!

Acked-by: John Fastabend <john.r.fastabend@intel.com>
