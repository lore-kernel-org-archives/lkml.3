Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbaLETic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:38:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaLETib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:38:31 -0500
Date: Fri, 5 Dec 2014 14:37:50 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141205193750.GB8251@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net>
 <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com>
 <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141205171501.GA1320@redhat.com>
 <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <20141205184808.GA2753@redhat.com>
 <CA+55aFwhdbcvvimPx0F7Q-BYDUSYDUODo5k5xeJuRCAtGB2dwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwhdbcvvimPx0F7Q-BYDUSYDUODo5k5xeJuRCAtGB2dwg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 11:31:11AM -0800, Linus Torvalds wrote:
 > On Fri, Dec 5, 2014 at 10:48 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > In the meantime, I rebooted into the same kernel, and ran trinity
 > > solely doing the lsetxattr syscalls.
 > 
 > Any particular reason for the lsetxattr guess? Just the last call
 > chain? I don't recognize it from the other traces, but maybe I just
 > didn't notice.

yeah just a wild guess, just that that trace looked so.. clean.

 > >   The load was a bit lower, so I
 > > cranked up the number of child processes to 512, and then this
 > > happened..
 >
 > Ugh. "dump_trace()" being broken and looping forever? I don't actually
 > believe it, because this isn't even on the exception stack (well, the
 > NMI dumper is, but that one worked fine - this is the "nested" dumping
 > of just the allocation call chain)
 >
 > Smells like more random callchains to me. Unless this one is repeatable.
 >
 > Limiting trinity to just lsetxattr is interesting. Did it make things
 > fail faster?

It sure failed quickly, but not in the "machine is totally locked up"
sense, just "shit is all corrupted" sense. So it might be a completely different
thing, or it could be a different manifestation of a corruptor.

I guess we'll see how things go now that I marked it 'bad'.

I'll give it a quick run with just lsetxattr again just to see what
happens, but before I leave this one run over the weekend, I'll switch
it back to "do everything", and pick it up again on Monday.

	Dave

