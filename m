Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3I3PsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:48:12 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:33643 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab3I3PsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:48:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130930152624.809243897@infradead.org>
References: <20130930152242.207382649@infradead.org>
	<20130930152624.809243897@infradead.org>
Date: Mon, 30 Sep 2013 08:48:09 -0700
X-Google-Sender-Auth: 7a4bk96Bt_Ho9QEIxW9wJjXHURs
Message-ID: <CA+55aFxDR6uSbCyg9Sp7bxoyzdUoN=TAfBLbkdPPgRqkv-TB1w@mail.gmail.com>
Subject: Re: [PATCH 2/6] sched, wait: Change timeout logic
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 8:22 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Commit 4c663cf ("wait: fix false timeouts when using
> wait_event_timeout()")

Btw, unrelated to the patch itselt: you seem to use the old broken
7-character short SHA1 format.

Yes, 7 hex characters is generally still unique. But no, it won't stay
so. The birthday paradox means that you start to get collisions more
quickly than you'd think, and the original 7-character hex string
default was done early in git development, when the BK repository was
considered "big", and that one was approaching having 16-bit commit
numbers.

Oh, how naive. In the eight+ years we've used git, we've flown past
that old 16-bit limit in commit numbers (we're now around 400k
commits), and we have over 3M objects. So we already have lots of
collisions in 7 characters. Now, git is smart enough that when it
picks a short form of the SHA1, it will never pick a collision, but
since the tree keeps growing, they can happen later.

As a result, I currently strongly suggest kernel-developers do

    git config --global core.abbrev 12

to set the default abbreviated SHA1 count to 12 characters, not the
old default of 7. That pushes out the collision worry to the point
where we're talking "later generations" rather than "forseeable
future".

                  Linus
