Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733Ab3DHCRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 22:17:54 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:40732 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760459Ab3DHCRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 22:17:53 -0400
Date: Mon, 8 Apr 2013 02:17:50 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [RFC PATCH] wfcqueue: implement __wfcq_enqueue_head() (v3)
Message-ID: <20130408021750.GA7306@dcvr.yhbt.net>
References: <20130407151316.GB10154@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130407151316.GB10154@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> Changes since v2:
> * Only issue cmpxchg() if queue was empty.
> * Add missing memory barrier.

Thanks!

There's a slight drop in performance either from the barrier or larger
code, but I'm not worried (it was around 9-10s before wfcqueue).

$ time ./eponeshotmt -c 1000000 -w 4 -t 4 -f 10
real    0m 5.83s
user    0m 1.35s
sys     0m 21.95s

I also ran v2 on Davide Libenzi's totalmess epoll stresser for a few
hours yesterday without failures.  Running totalmess right now on v3,
so far so good :)

Tested-by: Eric Wong <normalperson@yhbt.net>
