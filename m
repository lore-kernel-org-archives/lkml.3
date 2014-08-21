Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbaHUO6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:58:37 -0400
Received: from mail3.unitn.it ([193.205.206.24]:54545 "EHLO mail3.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaHUO6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:58:35 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2014 10:58:34 EDT
Date: Thu, 21 Aug 2014 16:47:58 +0200
From: Luca Abeni <luca.abeni@unitn.it>
To: Ingo Molnar <mingo@kernel.org>
Cc: Juri Lelli <juri.lelli@arm.com>, peterz@infradead.org,
        rdunlap@infradead.org, mingo@redhat.com, henrik@austad.us,
        raistlin@linux.it, juri.lelli@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] Documentation/scheduler/sched-deadline.txt:
 improve and clarify AC bits
Message-ID: <20140821164758.334a1cf7@luca-1225C>
In-Reply-To: <20140821133836.GA29495@gmail.com>
References: <1408611700-9420-1-git-send-email-juri.lelli@arm.com>
	<1408611700-9420-4-git-send-email-juri.lelli@arm.com>
	<20140821133836.GA29495@gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, 21 Aug 2014 15:38:37 +0200
Ingo Molnar <mingo@kernel.org> wrote:
[...]
> > + If the total utilisation sum_i(WCET_i/P_i) (sum of the
> > utilisations
> > + WCET_i/P_i of all the tasks in the system - notice that when
> > considering
> > + multiple tasks, the parameters of the i-th one are indicated with
> > the "_i"
> > + suffix) is larger than M (with M equal to the number of CPUs),
> > then the
> > + system will surely not be able to respect all of the deadlines,
> > and no
> > + execution time is guaranteed for non real-time tasks, which risk
> > to be
> > + starved by real-time tasks.
> 
> The last part doesn't really parse as correct English for me - 
> maybe also split this overly long sentence into two or three 
> sentences, to make it easier to understand?
Sorry about this; after re-reading the sentence, I agree it looks
confusing. What about:
"
If the total utilisation sum_i(WCET_i/P_i) is larger than M (with M
equal to the number of CPUs), then the scheduler can not be able to
respect all of the deadlines.
Note that the total utilisation is defined as the sum of the
utilisations WCET_i/P_i of all the real-time tasks in the system (when
considering multiple real-time tasks, the parameters of the i-th one are
indicated with the "_i" suffix).
Moreover, if the total utilisation is larger than M, then non real-time
tasks risk to be starved by real-time tasks.
"
Does this look more clear / acceptable?


				Thanks,
					Luca
