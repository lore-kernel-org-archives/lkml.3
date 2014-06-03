Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbaFCULA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:11:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934202AbaFCUK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:10:56 -0400
Date: Tue, 3 Jun 2014 22:09:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
Message-ID: <20140603200938.GA3384@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home> <20140603172632.GA27956@redhat.com> <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603160524.7895f225@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603160524.7895f225@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven, I am already sleeping, probably I just need to re-read your
email tomorrow, but...

On 06/03, Steven Rostedt wrote:
>
> When we convert the spin_lock into a rtmutex, when we hit the lock and
> it was contended (the task was in the process of exiting and it takes
> the lock to set tsk->sighand to NULL), instead of spinning, the task
> adds itself to the lock->wait_list and goes to sleep.

This is clear,

> Now, if that lock is released and reused (I didn't trace other tasks
> allocating these locks), it reinitializes the lock->wait_list.

How? From where? This should be done by sighand_ctor() only?

Oleg.

