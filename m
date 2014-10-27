Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbaJ0NsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 09:48:16 -0400
Received: from forward3o.mail.yandex.net ([37.140.190.32]:35301 "EHLO
	forward3o.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbaJ0NsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 09:48:14 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Burke Libbey <burke.libbey@shopify.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>
In-Reply-To: <20141027134508.GI3337@twins.programming.kicks-ass.net>
References: <20141024150746.GB25260@burke.local>
	 <20141024155805.GF21513@worktop.programming.kicks-ass.net>
	 <164441414171122@web11g.yandex.ru>
	 <20141027120734.GA3337@twins.programming.kicks-ass.net>
	 <20141027124002.GA4436@htj.dyndns.org>
	 <20141027132812.GG3337@twins.programming.kicks-ass.net>
	 <799391414416962@web4j.yandex.ru> <20141027134508.GI3337@twins.programming.kicks-ass.net>
Subject: Re: [PATCH] sched: reset sched_entity depth on changing parent
MIME-Version: 1.0
Message-Id: <1234171414417688@web26o.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 27 Oct 2014 16:48:08 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



27.10.2014, 16:45, "Peter Zijlstra" <peterz@infradead.org>:
> On Mon, Oct 27, 2014 at 04:36:02PM +0300, Kirill Tkhai wrote:
>> š27.10.2014, 16:28, "Peter Zijlstra" <peterz@infradead.org>:
>>> šOn Mon, Oct 27, 2014 at 08:40:02AM -0400, Tejun Heo wrote:
>>>> ššOn Mon, Oct 27, 2014 at 01:07:34PM +0100, Peter Zijlstra wrote:
>>>>> ššOn Fri, Oct 24, 2014 at 09:18:42PM +0400, Kirill Tkhai wrote:
>>>>>> ššI was seeking a places where task_group of a task may change. I can't understand
>>>>>> ššhow changing of parent's cgroup during fork() applies to a child.
>>>>> ššI didn't know we could change cgroup on fork(), I though the idea was
>>>>> ššyou always inherited your parents cgroup.
>>>>>
>>>>> ššHow can this be?
>>>> ššHmmm? -ENEEDMORECONTEXT but the inheriting happens at one point during
>>>> ššfork in cgroup_post_fork(). šThe child inherits whatever the parent
>>>> ššcgroup is at that point.
>>> šSo Kirill is saying that there is a race between fork and attach such
>>> šthat a child can end up in a different cgroup than the parent and we
>>> šneed to use the cgroup_subsys::fork call to fix that up.
>> šI mean cgroup is the same, but sched_task_group is other (sched_task_group
>> šis equal to parent's on the moment of dup_task_struct()).
>
> But that still means the parent changed cgroup during fork right? It
> started out in a different cgroup than it ended up with, and we need
> that .fork callback to fixup state.

Yeah, I'm agree.
