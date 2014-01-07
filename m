Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbaAGDCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:02:35 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:47363 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbaAGDCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:02:34 -0500
Message-ID: <1389063743.9937.7.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 5/4] futex: silence uninitialized warnings
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>
Date: Mon, 06 Jan 2014 19:02:23 -0800
In-Reply-To: <CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com>
References: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
	 <1388972316.4918.5.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-07 at 10:55 +0800, Linus Torvalds wrote:
> On Mon, Jan 6, 2014 at 9:38 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >  {
> >         int lock_taken, ret, force_take = 0;
> > -       u32 uval, newval, curval, vpid = task_pid_vnr(task);
> > +       u32 uval, newval, uninitialized_var(curval), vpid = task_pid_vnr(task);
> 
> Do you have some broken compiler? 

I only notice this when testing this patchset on our servers with RHEL
6.4 (gcc 4.4.7 20120313 (Red Hat 4.4.7-3)).

> I really tend to hate this kind of
> workarounds, because as mentioned, they can actually hide valid
> warnings, and it seems to be due to just stupid compilers. Are we
> perhaps better off trying to get people off the broken compiler
> versions instead?

As Darren points out, this path is unlikely to change, but I have no
particular preference otherwise.

