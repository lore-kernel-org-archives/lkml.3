Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaKUUCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:02:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaKUUCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:02:34 -0500
Date: Fri, 21 Nov 2014 15:00:52 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Josh Boyer <jboyer@redhat.com>, Justin Forbes <jforbes@redhat.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121200052.GA28668@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Lutomirski <luto@amacapital.net>, Tejun Heo <tj@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Don Zickus <dzickus@redhat.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Josh Boyer <jboyer@redhat.com>, Justin Forbes <jforbes@redhat.com>
References: <CALCETrUcuDh8c27cEHmoM7jo_kozJbYxV3p1H2LhmzBa16XOyQ@mail.gmail.com>
 <CA+55aFxU2q_-PVx+6fXGkXdAt3oaxvqxzy29Nrn989uTiVXvCg@mail.gmail.com>
 <20141121170805.GD30603@home.goodmis.org>
 <CA+55aFw+axXZhez-5x8zWFw1=6OazMbj=va8nt9GZHsrxsKewQ@mail.gmail.com>
 <CALCETrUp5kCnzFokCKVf3kn7K_d_5YP-phyNfL4rFR0tMZJi2A@mail.gmail.com>
 <CA+55aFxn_T=UgBUwqkRJvALygrNORaB6ox3nowvHpV6yFBfDoA@mail.gmail.com>
 <CA+55aFyEnuByhPM3FEdi=Q0WGuJWiBgtkWNAbRLHDpmPRaqnQA@mail.gmail.com>
 <20141121142301.564f7eb7@gandalf.local.home>
 <CA+55aFw6w+pkG7fs7tBVm7jV_TjsnEyG5XDdk+Ghf5Af+ELUeA@mail.gmail.com>
 <CA+55aFwOL8thHWWLtuzXkriEH1mJDCQO=NUsMRPptDXc6HC4sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwOL8thHWWLtuzXkriEH1mJDCQO=NUsMRPptDXc6HC4sg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 11:46:57AM -0800, Linus Torvalds wrote:
 
 > Anybody who seriously does virtualization uses hw virtualization that
 > is much better than it used to be. And the non-serious users aren't
 > that performance-sensitive by definition.
 > 
 > I note that the Fedora kernel config seems to include paravirt by
 > default, so you get a lot of the crazy overheads..

I'm not sure how many people actually use paravirt these days,
but the reason Fedora has it enabled still at least is probably
because..

config KVM_GUEST
         bool "KVM Guest support (including kvmclock)"
         depends on PARAVIRT

But tbh I've not looked at this stuff since it first got merged.
Will a full-virt system kvm boot a guest without KVM_GUEST enabled ?
(ie, is this just an optimisation for the paravirt case?)

I'm not a heavy virt user, so I don't even remember how a lot of
this stuff is supposed to work.

	Dave

