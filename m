Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3JQNwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:52:36 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:46011 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab3JQNwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:52:35 -0400
Message-ID: <1382017952.2045.150.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH] netfilter: fix ordering of jumpstack allocation and
 table update
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 17 Oct 2013 06:52:32 -0700
In-Reply-To: <1382016273-21993-1-git-send-email-will.deacon@arm.com>
References: <1382016273-21993-1-git-send-email-will.deacon@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-17 at 14:24 +0100, Will Deacon wrote:
> During kernel stability testing on an SMP ARMv7 system, Yalin Wang
> reported the following panic from the netfilter code:
> 

> On weakly ordered memory architectures, the writes to table->private
> and newinfo->jumpstack from CPU1 can be observed out of order by CPU0.
> Furthermore, on architectures which don't respect ordering of address
> dependencies (i.e. Alpha), the reads from CPU0 can also be re-ordered.
> 
> This patch adds an smp_wmb() before the assignment to table->private
> (which is essentially publishing newinfo) to ensure that all writes to
> newinfo will be observed before plugging it into the table structure.
> A dependent-read barrier is also added on the consumer side, to ensure
> the same ordering requirement are also respected there.
> 
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reported-by: Wang, Yalin <Yalin.Wang@sonymobile.com>
> Tested-by: Wang, Yalin <Yalin.Wang@sonymobile.com>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---

Nice catch !

Acked-by: Eric Dumazet <edumazet@google.com>


