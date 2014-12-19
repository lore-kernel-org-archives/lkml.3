Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaLSUzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:55:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbaLSUzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:55:15 -0500
Date: Fri, 19 Dec 2014 15:54:35 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141219205435.GA24499@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
	Peter Anvin <hpa@linux.intel.com>
References: <20141218161230.GA6042@redhat.com>
 <20141219024549.GB1671@redhat.com>
 <CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
 <20141219035859.GA20022@redhat.com>
 <20141219040308.GB20022@redhat.com>
 <CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
 <20141219145528.GC13404@redhat.com>
 <CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
 <CA+55aFyb6N47N2Jg75EmRxDTjFF2y_oy4dHNDeW_dyM4PUTDrA@mail.gmail.com>
 <CA+55aFzt_4Zrnek6381JFzm+3iV9d=JAeyx+=E9F8BeiWFb56g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzt_4Zrnek6381JFzm+3iV9d=JAeyx+=E9F8BeiWFb56g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 12:46:16PM -0800, Linus Torvalds wrote:
 > On Fri, Dec 19, 2014 at 11:51 AM, Linus Torvalds
 > <torvalds@linux-foundation.org> wrote:
 > >
 > > I do note that we depend on the "new mwait" semantics where we do
 > > mwait with interrupts disabled and a non-zero RCX value. Are there
 > > possibly even any known CPU errata in that area? Not that it sounds
 > > likely, but still..
 > 
 > Remind me what CPU you have in that machine again? The %rax value for
 > the mwait cases in question seems to be 0x32, which is either C7s-HSW
 > or C7s-BDW, and in both cases has the "TLB flushed" flag set.
 > 
 > I'm pretty sure you have a Haswell, I'm just checking. Which model?
 > I'm assuming it's family 6, model 60, stepping 3? I found you
 > mentioning i5-4670T in a perf thread.. That the one?

Yep.

vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Core(TM) i5-4670T CPU @ 2.30GHz
stepping	: 3
microcode	: 0x1a

 > Anyway, I don't actually believe in any CPU bugs, but you could try
 > "intel_idle.max_cstate=0" and see if that makes any difference, for
 > example.
 > 
 > Or perhaps just "intel_idle.max_cstate=1", which leaves intel_idle
 > active, but gets rid of the deeper sleep states (that incidentally
 > also play games with leave_mm() etc)

So I'm leaving Red Hat on Tuesday, and can realistically only do one
more experiment over the weekend before I give them this box back.

Right now I'm doing Chris' idea of "turn debugging back on,
and try without serial console".  Shall I try your suggestion
on top of that ?

I *hate* for this to be "the one that got away", but we've
at least gotten some good mileage out of this bug in the last
two months.  Who knows, maybe I'll find some new hardware that
will exhibit the same behaviour in the new year.

	Dave

