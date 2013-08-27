Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3H0XdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:33:08 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:49999 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780Ab3H0XdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:33:07 -0400
Date: Tue, 27 Aug 2013 23:33:00 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, edumazet@google.com,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] epoll: add a reschedule point in ep_free()
Message-ID: <20130827233300.GA14061@dcvr.yhbt.net>
References: <1376751997.21329.8.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376751997.21329.8.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> ep_free() might iterate on a huge set of epitems and hold
> cpu too long. Add two cond_resched() in order to yield cpu
> to other tasks. This is safe as we only hold mutexes in
> this function.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Theodore Ts'o <tytso@mit.edu>

Seems reasonable.  This isn't a remotely hot path and f_op->release
runs in a workqueue nowadays (right?).

Acked-by: Eric Wong <normalperson@yhbt.net>
