Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbaFKLPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 07:15:45 -0400
Received: from relay.parallels.com ([195.214.232.42]:49229 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaFKLPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:15:44 -0400
Message-ID: <1402485337.32126.29.camel@tkhai>
Subject: Re: [PATCH 1/2] sched: Rework migrate_tasks()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        <tkhai@yandex.ru>
Date: Wed, 11 Jun 2014 15:15:37 +0400
In-Reply-To: <20140611105733.GM6758@twins.programming.kicks-ass.net>
References: <20140611093417.27807.2288.stgit@tkhai>
	 <1402480330.32126.14.camel@tkhai>
	 <20140611105733.GM6758@twins.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Ср, 11/06/2014 в 12:57 +0200, Peter Zijlstra пишет:
> On Wed, Jun 11, 2014 at 01:52:10PM +0400, Kirill Tkhai wrote:
> > 
> > Currently migrate_tasks() skips throttled tasks,
> > because they are not pickable by pick_next_task().
> > 
> > These tasks stay on dead cpu even after they
> > becomes unthrottled. They are not schedulable
> > till user manually changes their affinity or till
> > cpu becomes alive again.
> > 
> > But for user this looks completely untransparent:
> > task hangs, but it's not obvious what he has to do,
> > because kernel does not report any problem.
> > 
> > This situation may easily be triggered intentionally.
> > Playing with extremely small cpu.cfs_quota_us causes
> > it almost in 100% cases. In usual life it's very rare,
> > but still possible for some unhappy user.
> > 
> 
> How about fixing the unthrottle code to validate the affinity?

I've begun that before, but found, it requires much more code
(three classes need this fix).

And this makes unthrottle code a little ugly (in my view).

	Kirill

