Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbaKSE7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 23:59:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbaKSE7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 23:59:31 -0500
Date: Tue, 18 Nov 2014 23:59:17 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119045917.GA17741@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Don Zickus <dzickus@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <CA+55aFy9dWtS5qh=-HT9M7hQPeWDMvdxEynr0p4aRkiGkV6gyQ@mail.gmail.com>
 <20141118020959.GA2091@redhat.com>
 <CA+55aFy65SmGXFeosNqvrgx+P6JQLrzpEYuwXdyeWtZwZsKxZg@mail.gmail.com>
 <20141118023930.GA2871@redhat.com>
 <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 08:40:55PM -0800, Linus Torvalds wrote:
 > On Tue, Nov 18, 2014 at 6:19 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > NMI watchdog: BUG: soft lockup - CPU#2 stuck for 21s! [trinity-c42:31480]
 > > CPU: 2 PID: 31480 Comm: trinity-c42 Not tainted 3.18.0-rc5+ #91 [loadavg: 174.61 150.35 148.64 9/411 32140]
 > > RIP: 0010:[<ffffffff8a1798b4>]  [<ffffffff8a1798b4>] context_tracking_user_enter+0xa4/0x190
 > > Call Trace:
 > >  [<ffffffff8a012fc5>] syscall_trace_leave+0xa5/0x160
 > >  [<ffffffff8a7d8624>] int_check_syscall_exit_work+0x34/0x3d
 > 
 > Hmm, if we are getting soft-lockups here, maybe it suggest too much exit-work.
 > 
 > Some TIF_NOHZ loop, perhaps? You have nohz on, don't you?

I do.

 > That makes me wonder: does the problem go away if you disable NOHZ?

I'll give it a try, and see what falls out overnight.

	Dave
