Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaAWTMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:12:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42837 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaAWTMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:12:37 -0500
Date: Thu, 23 Jan 2014 20:12:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: kmo@daterainc.com, target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140123191229.GW11314@laptop.programming.kicks-ass.net>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
 <20140121221852.GT9037@kmo>
 <1390420413.5567.949.camel@haakon3.risingtidesystems.com>
 <1390502404.5567.994.camel@haakon3.risingtidesystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390502404.5567.994.camel@haakon3.risingtidesystems.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 10:40:04AM -0800, Nicholas A. Bellinger wrote:
> On Wed, 2014-01-22 at 11:53 -0800, Nicholas A. Bellinger wrote:
> > Hi Peter,
> > 
> > Does this satisfy your questions..?
> > 
> > Do you have any more concerns about TASK_RUNNING + prepare_to_wait()
> > usage in percpu_ida_alloc() that need to be addressed before I can drop
> > this series into target-pending/for-next to address the original bug..?
> > 
> 
> Given the silence, 

You mean the silence in which I send a 4+ emails earlier today?

> I'll assume your OK with the initial TASK_RUNNING +
> prepare_to_wait() bit, right..?

No, I would prefer not to do that. While it does work its awkward at
best.
