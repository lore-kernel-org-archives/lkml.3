Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaHVOQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:16:25 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63481 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099AbaHVOQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:16:21 -0400
Message-ID: <1408716976.5604.18.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 22 Aug 2014 07:16:16 -0700
In-Reply-To: <53F70887.8030602@redhat.com>
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com>
	 <1408608310-13579-2-git-send-email-jasowang@redhat.com>
	 <1408683665.5648.69.camel@marge.simpson.net>
	 <20140822073653.GA7372@gmail.com> <53F70887.8030602@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 17:08 +0800, Jason Wang wrote:

> But this is just for current process. We want to determine whether or
> not it was worth to loop busily in current process by checking if
> there's any another runnable processes or callbacks. And what we need
> here is just a simple and lockless hint which can't be wrong but may be
> inaccurate to exit the busy loop. The net code does not depends on this
> hint to do scheduling or yielding.
> 
> How about just introducing a boolean helper like current_can_busy_loop()
> and return true in one of the following conditions:
> 
> - Current task is SCHED_FIFO
> - Current task is neither SCHED_FIFO nor SCHED_IDLE and no other
> runnable processes or pending RCU callbacks in current cpu
> 
> And add warns to make sure it can only be called in process context.


1) Any reasons Eliezer Tamir is not included in the CC list ?

   He is the busypoll author after all, and did nothing wrong to be
banned from these patches ;)

2) It looks like sk_buy_loop() should not be inlined, its is already too
big.




