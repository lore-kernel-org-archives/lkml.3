Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaCIRQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 13:16:35 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:40689 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaCIRQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:16:33 -0400
MIME-Version: 1.0
In-Reply-To: <20140309170909.GA13335@redhat.com>
References: <1393537704.2899.3.camel@buesod1.americas.hpqcorp.net>
	<20140308184040.GA29602@redhat.com>
	<CA+55aFw88xiY+o5FE6VtHNkpUZDK3FPt31oCpNsgn1BH7wAPZw@mail.gmail.com>
	<20140308194405.GA32403@redhat.com>
	<CA+55aFzk=XtRFPQM4rGgTXj8AD2RLrm5pfAsKwGOZPHLgb+Ziw@mail.gmail.com>
	<20140309125710.GA1829@redhat.com>
	<CA+55aFxyGJFEz5NnHtK1wn8oDLy9n-CttttKL_0AM69gN8JzxQ@mail.gmail.com>
	<20140309170909.GA13335@redhat.com>
Date: Sun, 9 Mar 2014 10:16:32 -0700
X-Google-Sender-Auth: N-6oKYefrwG9jZ1iCQMQruHiqoc
Message-ID: <CA+55aFxEGj9poWNLAncvrrOTzjDtrwMnOM_d3ACqRkcvY86qHA@mail.gmail.com>
Subject: Re: [PATCH v4] mm: per-thread vma caching
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Davidlohr Bueso <davi@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2014 at 10:09 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> But it's not the "while we're setting up a new thread", it is "since
> vmacache_valid() was called list time". And the cloning task can just
> sleep(A_LOT) and then do CLONE_VM.
>
> Of course, of course, this race is pute theoretical anyway. But imho
> makes sense to fix anyway, and the natural/trivial approach is just to
> move vmacache_flush(tsk) from dup_mm() to copy_mm(), right after the
> "if (!oldmm)" check.

Fair enough, you've convinced me it's subtle enough that we do not
want to play games..

          Linus
