Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926AbaKTUGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:06:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaKTUGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:06:39 -0500
Date: Thu, 20 Nov 2014 15:06:03 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141120200603.GA19499@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Don Zickus <dzickus@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
References: <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <546D0530.8040800@mit.edu>
 <20141120152509.GA5412@redhat.com>
 <CA+55aFzP0jivKYWUVwt==wNaBjZM+aBQLMT=Td+2cOVKSvm-dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzP0jivKYWUVwt==wNaBjZM+aBQLMT=Td+2cOVKSvm-dQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 11:43:07AM -0800, Linus Torvalds wrote:
 
 > You know what? I'm seriously starting to think that these bugs aren't
 > actually real. Or rather, I don't think it's really a true softlockup,
 > because most of them seem to happen in totally harmless code.
 > 
 > So I'm wondering whether the real issue might not be just this:
 > 
 >    [loadavg: 164.79 157.30 155.90 37/409 11893]
 > 
 > together with possibly a scheduler issue and/or a bug in the smpboot
 > thread logic (that the watchdog uses) or similar.
 > 
 > That's *especially* true if it turns out that the 3.17 problem you saw
 > was actually a perf bug that has already been fixed and is in stable.
 > We've been looking at kernel/smp.c changes, and looking for x86 IPI or
 > APIC changes, and found some harmlessly (at least on x86) suspicious
 > code and this exercise might be worth it for that reason, but what if
 > it's really just a scheduler regression.

I started a run against 3.17 with the perf fixes. If that survives
today, I'll start a bisection tomorrow.

 > There's been a *lot* more scheduler changes since 3.17 than the small
 > things we've looked at for x86 entry or IPI handling. And the
 > scheduler changes have been about things like overloaded scheduling
 > groups etc, and I could easily imaging that some bug *there* ends up
 > causing the watchdog process not to schedule.

One other data point: I put another box into service for testing,
but it's considerably slower (a ~6 year old Xeon vs the Haswell).
Maybe it's just because it's so much slower that it'll take longer,
(or slow enough that the bug is masked) but that machine hasn't had
a problem yet in almost a day of runtime.

	Dave

