Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab3CKVZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:25:18 -0400
Received: from mail.openrapids.net ([64.15.138.104]:45254 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754132Ab3CKVZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:25:14 -0400
Date: Mon, 11 Mar 2013 17:25:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>
Subject: Re: wfcqueue (in Userspace RCU) for Linux kernel (for epoll)
Message-ID: <20130311212510.GA9829@Krystal>
References: <20130311193541.GA11149@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311193541.GA11149@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Wong (normalperson@yhbt.net) wrote:
> Hi, I'm looking to reduce contention for the ep->lock spin lock in epoll.
> 
> I came across wfcqueue in Userspace RCU and am wondering if there's any
> reason (other that lack of developer time/users) it hasn't been adapted
> for the Linux kernel.
> 
> I'd be happy to do the work if it's suitable (and omit parts which
> may not be, such as busy wait).

Hi Eric,

I'm glad you're interested in our data structure!

I actually have a port ready, I just lacked the time for thorough
testing and also lacked users of the API at kernel-level. It looks like
now would be a good time to send the patch your way as a RFC!

> Using a mutex lock (while in process context) for dequeue works for
> epoll.  I mainly want a lock-free enqueue for ep_poll_callback since
> that may be called in IRQ context.

You'd get even better than this: wait-free enqueue, with a simple xchg
and store.

> 
> I suppose I can also use the llist LIFO in ep_poll_callback and
> reverse that while in process context, too...

Yeah, but that seems more expensive than just having the list in the
right order already. ;)

Patch incoming in a separate post,

Thanks,

Mathieu

> 
> 
> ref: http://git.lttng.org/userspace-rcu.git

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
