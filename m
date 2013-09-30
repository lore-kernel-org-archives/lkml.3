Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3I3RDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:03:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3I3RDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:03:30 -0400
Date: Mon, 30 Sep 2013 10:03:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH, v2] anon_vmas: Convert the rwsem to an rwlock_t
Message-Id: <20130930100351.7843a62b.akpm@linux-foundation.org>
In-Reply-To: <20130928195207.GA31245@gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	<20130928074144.GA17773@gmail.com>
	<CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
	<20130928192123.GA8228@gmail.com>
	<20130928193739.GA8642@gmail.com>
	<CA+55aFyMXxH-PGewqxse=VJzMdHWkyN4iKMh-VgQ1X2yJFnAgw@mail.gmail.com>
	<20130928195207.GA31245@gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Sep 2013 21:52:07 +0200 Ingo Molnar <mingo@kernel.org> wrote:

> Here's a an almost totally untested patch to convert the anon vma lock to 
> an rwlock_t.

Both the anon vma lock and i_mmap_lock used to be spinlocks.  Peter
turned them both into sleeping locks in this series:
https://lkml.org/lkml/2011/4/1/141

Later, Ingo turned the anon vma lock from an rwsem into a mutex
(https://lkml.org/lkml/2012/12/1/141) to permit a scalability fix
(https://lkml.org/lkml/2012/12/1/142).

Let's convince ourselves that we won't be undoing things which will
return to bite us?

