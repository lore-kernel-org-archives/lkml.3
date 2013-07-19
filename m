Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3GSX7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:59:31 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:57480 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab3GSX7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:59:30 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jul 2013 19:59:30 EDT
Date: Fri, 19 Jul 2013 23:50:08 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: strange crashes in tcp_poll() via epoll_wait
Message-ID: <20130719235008.GA4518@dcvr.yhbt.net>
References: <1374251057.26476.17.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374251057.26476.17.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Hi Al
> 
> I tried to debug strange crashes in tcp_poll() called from
> sys_epoll_wait() -> sock_poll()
> 
> The symptom is that sock->sk is NULL and we therefore dereference a NULL
> pointer.
> 
> It's really rare crashes but still, it would be nice to understand where
> is the bug. Presumably latest kernels would crash in sock_poll() because
> of the sk_can_busy_loop(sock->sk) call.
> 
> We do test sock->sk being NULL in sock_fasync(), but epoll should be
> safe because of existing synchronization (epmutex) ?

It should be safe because of ep->mtx, actually, as epmutex is not taken
in sys_epoll_wait.

I took a look at this but have not found anything.  I've yet to see this
this on my machines.

When did you start noticing this?
