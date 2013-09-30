Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733Ab3I3RZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:25:14 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33644 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab3I3RZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130930100351.7843a62b.akpm@linux-foundation.org>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	<20130928074144.GA17773@gmail.com>
	<CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
	<20130928192123.GA8228@gmail.com>
	<20130928193739.GA8642@gmail.com>
	<CA+55aFyMXxH-PGewqxse=VJzMdHWkyN4iKMh-VgQ1X2yJFnAgw@mail.gmail.com>
	<20130928195207.GA31245@gmail.com>
	<20130930100351.7843a62b.akpm@linux-foundation.org>
Date: Mon, 30 Sep 2013 10:25:10 -0700
X-Google-Sender-Auth: GCMh_i8-8UgeO54wcGbcmroZNJ8
Message-ID: <CA+55aFzOXzQike3zjTdhvB+eqSYDgKzwP7zh4diZnwROmSeu8Q@mail.gmail.com>
Subject: Re: [PATCH, v2] anon_vmas: Convert the rwsem to an rwlock_t
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@elte.hu>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 10:03 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Let's convince ourselves that we won't be undoing things which will
> return to bite us?

Umm. We call them regressions, and we fix them.

As already mentioned, the original switch to a mutex didn't even have
any good explanation for it, much less actual data.

When we make mistakes, we'd better realize it and fix them, rather
than assume that they were fixes just because they were made.

The performance numbers are pretty damn compelling for this having
been a major mistake.

(Of course, the current performance numbers also contain the
conversion to a rwlock_t rather than back to a spinlock, which may
actually help wrt the original situation too)

                 Linus
