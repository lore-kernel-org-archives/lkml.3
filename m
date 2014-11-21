Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbaKUOuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:50:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216AbaKUOui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:50:38 -0500
Date: Fri, 21 Nov 2014 09:50:00 -0500
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141121145000.GA10364@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Don Zickus <dzickus@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
References: <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141119021902.GA14216@redhat.com>
 <CA+55aFw13opSu6ETXgVo1tjrP+1PLkbsiKewEqRgdBKyBKALWA@mail.gmail.com>
 <20141119145902.GA13387@redhat.com>
 <546D0530.8040800@mit.edu>
 <20141120152509.GA5412@redhat.com>
 <CA+55aFzP0jivKYWUVwt==wNaBjZM+aBQLMT=Td+2cOVKSvm-dQ@mail.gmail.com>
 <20141121063742.GA29250@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121063742.GA29250@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 07:37:42AM +0100, Ingo Molnar wrote:

 > It might make sense to disable the softlockup detector altogether 
 > and just see whether trinity finishes/wedges, whether a login 
 > over the console is still possible - etc.

I can give that a try later.

 > The softlockup messages in themselves are only analytical, unless 
 > CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1 is used.

Hm, I don't recall why I had that set. That should make things easier
to debug if the machine stays alive a little longer rather than
panicing. At least it might make sure that I get the full traces
over usb-serial.

Additionally, it might make ftrace an option.

The last thing I tested was 3.17 plus the perf fixes Frederic pointed
out yesterday. It's survived 20 hours of runtime, so I'm back to
believing that this is a recent (ie, post 3.17 bug).

Running into the weekend though, so I'm not going to get to bisecting
until Monday probably. So maybe I'll try your idea at the top of this
mail in my over-the-weekend run.

	Dave

