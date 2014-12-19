Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaLSPNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:13:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaLSPNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:13:20 -0500
Date: Fri, 19 Dec 2014 10:12:10 -0500
From: Dave Jones <davej@redhat.com>
To: Chris Mason <clm@fb.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141219151210.GD13404@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
	Peter Anvin <hpa@linux.intel.com>
References: <20141215055707.GA26225@redhat.com>
 <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
 <CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
 <20141218051327.GA31988@redhat.com>
 <1418918059.17358.6@mail.thefacebook.com>
 <20141218161230.GA6042@redhat.com>
 <20141219024549.GB1671@redhat.com>
 <CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
 <20141219035859.GA20022@redhat.com>
 <1418999437.13012.1@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418999437.13012.1@mail.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 09:30:37AM -0500, Chris Mason wrote:

 > > in more recent builds. I've been running kitchen-sink debug kernels
 > > for my trinity runs for the last three years, and it's only this
 > > last few months that this has got to be enough of a problem that I'm
 > > not seeing the more interesting bugs. (Or perhaps we're just getting
 > > better at fixing them in -next now, so my runs are lasting longer..)
 > 
 > I think we're also adding more and more debugging.  It's definitely a 
 > good thing, but I think a lot of them are expected to stay off until 
 > you're trying to track down a specific problem.  I do always run with 
 > CONFIG_DEBUG_PAGEALLOC here and lock debugging/lockdep, and aside from 
 > being slow haven't hit trouble.

I think in the new year I'll hack up something I run on each kernel
build that picks a random subset of the debug options.  It's been on
my whiteboard for a while anyway, to try and get more 'real world'
looking kernel testing.  If I can get enough machines to test on,
it should still mean we get enough testing that we'll catch stuff early on.

It does seem like things have gotten so 'heavy' that a lot of what I've
been seeing have been ghosts. That said, there's also been several
real problems that have been shaken out during this thread over the last
two months, so I don't feel like we've wasted our time entirely.

 > I know it's 3.16 instead of 3.17, but 16K stacks are probably 
 > increasing the pressure on everything in these runs.  It's my favorite 
 > kernel feature this year, but it's likely to make trinity hurt more on 
 > memory constrained boxes.

That's actually a good point. Even just the forking/exiting overhead
is now much higher when we're starting & tearing down hundreds of child
processes every few seconds. Couple that with some children 'stuck'
in VM functions, and I could see the kernel struggling to find order
2 pages for a while. (Though never to the point where it fails).

 > I know you have traces with a ton more output, but I'm still 
 > wondering if usb-serial and printk from NMI really get along well.  I'd 
 > try with debugging back on and serial consoles off.  We carry patches 
 > to make oom print less, just because the time spent on our slow 
 > emulated serial console is enough to back the box up into a death 
 > spiral.

So I'm running out of time on this, and will realistically only
have this machine over the weekend.  I can give that a try, hopefully
if it fails, it'll fail early so we can try something else.

	Dave

