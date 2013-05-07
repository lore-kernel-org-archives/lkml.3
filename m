Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3EGUJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:09:54 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47027 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752070Ab3EGUJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:09:52 -0400
Date: Tue, 7 May 2013 16:09:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v2] epoll: avoid spinlock contention with wfcqueue
Message-ID: <20130507200948.GC8879@Krystal>
References: <20130314044215.GA27312@dcvr.yhbt.net> <20130318110722.GA8798@dcvr.yhbt.net> <20130318130649.GA15947@Krystal> <20130318173237.GB8798@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318173237.GB8798@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Wong (normalperson@yhbt.net) wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

[...]

> > I'm also not entirely sure why you need to add enum epoll_item_state
> > along with expensive atomic ops to compute the state.  Wouldn't it be
> > enough to know in which queue the nodes are located ? If need be, you
> > could add new queues, e.g. one per state. So instead of marking states,
> > you would simply re-enqueue the nodes into per-state queues. This would
> > simplify zombie management and save a couple of brains in the process. ;-)
> 
> Is there a quick way to know which queue the node is located?

Unfortunately, no. We don't do such "tagging", so you'd have to iterate
on all list items to find this info in the worse case.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
