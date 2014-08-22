Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbaHVIbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:31:19 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:45119 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbaHVIbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:31:16 -0400
Date: Fri, 22 Aug 2014 10:31:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Juri Lelli <juri.lelli@arm.com>, peterz@infradead.org,
        rdunlap@infradead.org, mingo@redhat.com, henrik@austad.us,
        raistlin@linux.it, juri.lelli@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] Documentation/scheduler/sched-deadline.txt:
 improve and clarify AC bits
Message-ID: <20140822083110.GB8771@gmail.com>
References: <1408611700-9420-1-git-send-email-juri.lelli@arm.com>
 <1408611700-9420-4-git-send-email-juri.lelli@arm.com>
 <20140821133836.GA29495@gmail.com>
 <20140821164758.334a1cf7@luca-1225C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821164758.334a1cf7@luca-1225C>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luca Abeni <luca.abeni@unitn.it> wrote:

> Hi Ingo,
> 
> On Thu, 21 Aug 2014 15:38:37 +0200
> Ingo Molnar <mingo@kernel.org> wrote:
> [...]
> > > + If the total utilisation sum_i(WCET_i/P_i) (sum of the
> > > utilisations
> > > + WCET_i/P_i of all the tasks in the system - notice that when
> > > considering
> > > + multiple tasks, the parameters of the i-th one are indicated with
> > > the "_i"
> > > + suffix) is larger than M (with M equal to the number of CPUs),
> > > then the
> > > + system will surely not be able to respect all of the deadlines,
> > > and no
> > > + execution time is guaranteed for non real-time tasks, which risk
> > > to be
> > > + starved by real-time tasks.
> > 
> > The last part doesn't really parse as correct English for me - 
> > maybe also split this overly long sentence into two or three 
> > sentences, to make it easier to understand?
> Sorry about this; after re-reading the sentence, I agree it looks
> confusing. What about:

Looks good to me, with a few details:

> "
> If the total utilisation sum_i(WCET_i/P_i) is larger than M (with M
> equal to the number of CPUs), then the scheduler can not be able to
> respect all of the deadlines.

s/can not be able to respect/is unable to respect

> Note that the total utilisation is defined as the sum of the
> utilisations WCET_i/P_i of all the real-time tasks in the system (when
> considering multiple real-time tasks, the parameters of the i-th one are
> indicated with the "_i" suffix).

The parentheses are a bit confusing here - they come after a 
half finished sentence - which at the end turns out to have 
ended.

How about something like:

> Note that total utilisation is defined as the sum of the 
> utilisations WCET_i/P_i over all the real-time tasks in the 
> system. When considering multiple real-time tasks, the 
> parameters of the i-th task are indicated with the "_i" 
> suffix.

?

> Moreover, if the total utilisation is larger than M, then non real-time
> tasks risk to be starved by real-time tasks.

How about:

> Moreover, if the total utilisation is larger than M, then we 
> risk starving non- real-time tasks by real-time tasks.

?

Thanks,

	Ingo
