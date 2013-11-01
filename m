Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3KASzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:55:07 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:61606 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3KASzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:55:05 -0400
MIME-Version: 1.0
In-Reply-To: <CANN689EQ9d1BubEZ9txfWfKJEZQ5_zWvV5V_CyPCP5cRUw-oAw@mail.gmail.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
	<20131101080135.GB25547@gmail.com>
	<1383328187.2653.5.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFzzdLn1xqyGobtP2yo7es+XOgt10Kr-9FRHvg-9eE3cyg@mail.gmail.com>
	<CANN689EQ9d1BubEZ9txfWfKJEZQ5_zWvV5V_CyPCP5cRUw-oAw@mail.gmail.com>
Date: Fri, 1 Nov 2013 11:55:03 -0700
X-Google-Sender-Auth: J4XxV0K9Nr5o2P_-38bJciW8Xgs
Message-ID: <CA+55aFyLPpDzgYJfXFMMGaWT4JOsSN0be_ntazjzc+GEg14V2A@mail.gmail.com>
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to rwlock_t
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 1, 2013 at 11:47 AM, Michel Lespinasse <walken@google.com> wrote:
>
> Should copy Andrea on this. I talked with him during KS, and there are
> no current in-tree users who are doing such sleeping; however there
> are prospective users for networking (RDMA) or GPU stuff who want to
> use this to let hardware directly copy data into user mappings.

Tough.

I spoke up the first time this came up and I'll say the same thing
again: we're not screwing over the VM subsystem because some crazy
user might want to do crazy and stupid things that nobody sane cares
about.

The whole "somebody might want to .." argument is just irrelevant.
Some people want to sleep in interrupt handlers too, or while holding
random spinlocks. Too bad. They don't get to, because doing that
results in problems for the rest of the system.

Our job in the kernel is to do the best job technically that we can.
And sometimes that very much involves saying "No, you can't do that".

We have limitations in the kernel. The stack is of limited size. You
can't allocate arbitrarily sized memory. You must follow some very
strict rules.

If people can't handle that, then they can go cry to mommy, and go
back to writing user mode code. In the kernel, you have to live with
certain constraints that makes the kernel better.

               Linus
