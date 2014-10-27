Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaJ0Nrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:47:40 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:41223 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaJ0Nrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:47:39 -0400
Date: Mon, 27 Oct 2014 09:47:35 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Burke Libbey <burke.libbey@shopify.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
Subject: Re: [PATCH] sched: reset sched_entity depth on changing parent
Message-ID: <20141027134735.GG4436@htj.dyndns.org>
References: <20141024150746.GB25260@burke.local>
 <20141024155805.GF21513@worktop.programming.kicks-ass.net>
 <164441414171122@web11g.yandex.ru>
 <20141027120734.GA3337@twins.programming.kicks-ass.net>
 <20141027124002.GA4436@htj.dyndns.org>
 <20141027132812.GG3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027132812.GG3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter, Kirill.

On Mon, Oct 27, 2014 at 02:28:12PM +0100, Peter Zijlstra wrote:
...
> So Kirill is saying that there is a race between fork and attach such
> that a child can end up in a different cgroup than the parent and we
> need to use the cgroup_subsys::fork call to fix that up.
> 
> I was always under the impression that fork was an 'atomic' operation
> from the point of cgroups, an attach (or move) would happen either
> before the fork or after, not during. But I appear to be mistaken in
> that assumption, going by the comments around cgroup_post_fork().

cgroup migration is atomic against threadgroup changes - tasks joining
or leaving the threadgroup.  If a process is forking a child, the
child inherits the parent's cgroup at one point while forking and the
parent may have changed its cgroup while fork was in progress.  So,
yeah, it can't depend on the dup'd result to be correct.

Thanks.

-- 
tejun
