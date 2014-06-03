Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885AbaFCUEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:04:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933671AbaFCUEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:04:31 -0400
Date: Tue, 3 Jun 2014 22:03:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
Message-ID: <20140603200322.GC1105@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home> <20140603172632.GA27956@redhat.com> <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com> <20140603200125.GB1105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603200125.GB1105@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn, sorry for noise...

On 06/03, Oleg Nesterov wrote:
>
> I'll try to recheck rt_mutex_unlock() tomorrow. _Perhaps_ rcu_read_unlock()
> should be shifted from lock_task_sighand() to unlock_task_sighand() to
> ensure that rt_mutex_unlock() does nothihg with this memory after it
> makes another lock/unlock possible.

I meant, we need to ensure it does nothing with this memory, otherwise we
need to delay rcu_read_unlock() till unlock_task_sighand().

Oleg.

