Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaJ0NgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:36:09 -0400
Received: from forward14.mail.yandex.net ([95.108.130.92]:55878 "EHLO
	forward14.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaJ0NgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:36:07 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Cc: Burke Libbey <burke.libbey@shopify.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
In-Reply-To: <20141027132812.GG3337@twins.programming.kicks-ass.net>
References: <20141024150746.GB25260@burke.local>
	 <20141024155805.GF21513@worktop.programming.kicks-ass.net>
	 <164441414171122@web11g.yandex.ru>
	 <20141027120734.GA3337@twins.programming.kicks-ass.net>
	 <20141027124002.GA4436@htj.dyndns.org> <20141027132812.GG3337@twins.programming.kicks-ass.net>
Subject: Re: [PATCH] sched: reset sched_entity depth on changing parent
MIME-Version: 1.0
Message-Id: <799391414416962@web4j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 27 Oct 2014 16:36:02 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



27.10.2014, 16:28, "Peter Zijlstra" <peterz@infradead.org>:
> On Mon, Oct 27, 2014 at 08:40:02AM -0400, Tejun Heo wrote:
>> šOn Mon, Oct 27, 2014 at 01:07:34PM +0100, Peter Zijlstra wrote:
>>> šOn Fri, Oct 24, 2014 at 09:18:42PM +0400, Kirill Tkhai wrote:
>>>> šI was seeking a places where task_group of a task may change. I can't understand
>>>> šhow changing of parent's cgroup during fork() applies to a child.
>>> šI didn't know we could change cgroup on fork(), I though the idea was
>>> šyou always inherited your parents cgroup.
>>>
>>> šHow can this be?
>> šHmmm? -ENEEDMORECONTEXT but the inheriting happens at one point during
>> šfork in cgroup_post_fork(). šThe child inherits whatever the parent
>> šcgroup is at that point.
>
> So Kirill is saying that there is a race between fork and attach such
> that a child can end up in a different cgroup than the parent and we
> need to use the cgroup_subsys::fork call to fix that up.

I mean cgroup is the same, but sched_task_group is other (sched_task_group
is equal to parent's on the moment of dup_task_struct()).


> I was always under the impression that fork was an 'atomic' operation
> from the point of cgroups, an attach (or move) would happen either
> before the fork or after, not during. But I appear to be mistaken in
> that assumption, going by the comments around cgroup_post_fork().
