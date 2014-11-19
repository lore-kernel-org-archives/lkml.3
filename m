Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbaKSWUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:20:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991AbaKSWUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 17:20:00 -0500
Date: Wed, 19 Nov 2014 17:18:19 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141119221819.GA24195@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Don Zickus <dzickus@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
References: <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <CA+55aFxBb+aH6GdhbWECkh+wDwsHv43O1ryy4u20O8Bk-oDz+g@mail.gmail.com>
 <CALCETrXT3XvfoWvX2hBeW-S2nUHoeLqFFbnW-66H34_aUXKn8g@mail.gmail.com>
 <CA+55aFyRdYDzj_d42paCy-Tg33ysEmkTVVZ+A97b+-0LF_6Yeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyRdYDzj_d42paCy-Tg33ysEmkTVVZ+A97b+-0LF_6Yeg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 11:38:09AM -0800, Linus Torvalds wrote:

 > > Is it possible that we've managed to return to userspace with
 > > interrupts off somehow?  A loop in userspace that somehow has
 > > interrupts off can cause all kinds of fun lockups.
 > 
 > That sounds unlikely, but if there is some stack corruption going on.
 > 
 > However, it wouldn't even explain things, because even if interrupts
 > had been disabled in user space, and even if that popf got executed,
 > this wouldn't be where they got enabled. That would be the :"sti" in
 > the system call entry path (hidden behind the ENABLE_INTERRUPTS
 > macro).
 > 
 > Of course, maybe Dave has paravirtualization enabled (what a crock
 > _that_ is), and there is something wrong with that whole code.

I've had HYPERVISOR_GUEST disabled for a while, which also disables
the paravirt code afaics.

	Dave

