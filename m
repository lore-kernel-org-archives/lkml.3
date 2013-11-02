Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3KBDTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 23:19:04 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:17197 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab3KBDTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 23:19:03 -0400
Message-ID: <1383362336.2444.8.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to
 rwlock_t
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 01 Nov 2013 20:18:56 -0700
In-Reply-To: <CA+55aFyLPpDzgYJfXFMMGaWT4JOsSN0be_ntazjzc+GEg14V2A@mail.gmail.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
	 <20131101080135.GB25547@gmail.com>
	 <1383328187.2653.5.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFzzdLn1xqyGobtP2yo7es+XOgt10Kr-9FRHvg-9eE3cyg@mail.gmail.com>
	 <CANN689EQ9d1BubEZ9txfWfKJEZQ5_zWvV5V_CyPCP5cRUw-oAw@mail.gmail.com>
	 <CA+55aFyLPpDzgYJfXFMMGaWT4JOsSN0be_ntazjzc+GEg14V2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 11:55 -0700, Linus Torvalds wrote:
> On Fri, Nov 1, 2013 at 11:47 AM, Michel Lespinasse <walken@google.com> wrote:
> >
> > Should copy Andrea on this. I talked with him during KS, and there are
> > no current in-tree users who are doing such sleeping; however there
> > are prospective users for networking (RDMA) or GPU stuff who want to
> > use this to let hardware directly copy data into user mappings.
> 
> Tough.
> 
> I spoke up the first time this came up and I'll say the same thing
> again: we're not screwing over the VM subsystem because some crazy
> user might want to do crazy and stupid things that nobody sane cares
> about.
> 
> The whole "somebody might want to .." argument is just irrelevant.

Ok, I was under the impression that this was something already in the
kernel and hence "too late to go back". Based on the results I'm
definitely in favor of the whole rwlock conversion.

Thanks,
Davidlohr

