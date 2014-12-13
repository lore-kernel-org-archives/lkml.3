Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbaLMCdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 21:33:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaLMCdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 21:33:31 -0500
Date: Fri, 12 Dec 2014 21:32:52 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141213023252.GA2881@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sasha.levin@oracle.com>, Chris Mason <clm@fb.com>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFxVeti8pU=Y_w54oGb8syGduOySAp-ag+KsCom-c12e-Q@mail.gmail.com>
 <1417806247.4845.1@mail.thefacebook.com>
 <CA+55aFz3iUyV9=_rVUdO0WPoOyOKOYkcHCxb3p=2fgSHtCTNgw@mail.gmail.com>
 <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <548A122C.8000906@oracle.com>
 <CA+55aFw68nC+5s=iX2R4SLsgG3nBvURmDXYvX5pFJgHBnQoHMA@mail.gmail.com>
 <548A2165.9030107@oracle.com>
 <548B8046.4040808@oracle.com>
 <CA+55aFyRW6su2J5O+ie70GqMvO3TYuSj93xwyJaPjGK1M=vUgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyRW6su2J5O+ie70GqMvO3TYuSj93xwyJaPjGK1M=vUgA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 04:23:16PM -0800, Linus Torvalds wrote:
 > On Fri, Dec 12, 2014 at 3:54 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
 > >
 > > I ran bisection on trinity, rather than the kernel, and got the following
 > > result:
 > 
 > Heh. That commit is pretty small, but I guess the effect of having a
 > number of regular files open and being used on the trinity loads can
 > be almost arbitrarily large.
 > 
 > Where do those files get opened? What filesystem?

in the cwd where trinity is run from. In my case, ext4

 > > I've been running trinity f2be2d5ff^ on -next for two hours now, and there's
 > > no sign of a lockup. Previously it took ~10 minutes trigger.
 > 
 > DaveJ?  Is there anything limiting the size of those files?

Nope. We could for eg, do a random truncate() with a huge size, and it would
try and create something enormous.  write()'s are limited to page size,
there might be some other syscalls I haven't added safety guards to.

	Dave

