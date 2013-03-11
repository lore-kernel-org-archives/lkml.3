Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab3CKTfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:35:43 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:57319 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab3CKTfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:35:42 -0400
Date: Mon, 11 Mar 2013 19:35:41 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>
Subject: wfcqueue (in Userspace RCU) for Linux kernel (for epoll)
Message-ID: <20130311193541.GA11149@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm looking to reduce contention for the ep->lock spin lock in epoll.

I came across wfcqueue in Userspace RCU and am wondering if there's any
reason (other that lack of developer time/users) it hasn't been adapted
for the Linux kernel.

I'd be happy to do the work if it's suitable (and omit parts which
may not be, such as busy wait).

Using a mutex lock (while in process context) for dequeue works for
epoll.  I mainly want a lock-free enqueue for ep_poll_callback since
that may be called in IRQ context.

I suppose I can also use the llist LIFO in ep_poll_callback and
reverse that while in process context, too...


ref: http://git.lttng.org/userspace-rcu.git
