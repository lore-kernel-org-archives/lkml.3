Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbaD1XFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:05:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaD1XFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:05:02 -0400
Date: Mon, 28 Apr 2014 16:05:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: Richard Weinberger <richard@nod.at>, Randy Dunlap <rdunlap@infradead.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, umgwanakikbuti@gmail.com
Subject: Re: mmotm 2014-04-24-13-07 uploaded
Message-Id: <20140428160501.df072b191fce77ab5d042054@linux-foundation.org>
In-Reply-To: <20140428213909.GA16623@linux.vnet.ibm.com>
References: <20140424200837.727695A407C@corp2gmr1-2.hot.corp.google.com>
	<535992DD.3060808@infradead.org>
	<20140425100459.7824f676@annuminas.surriel.com>
	<535AC91A.1070504@infradead.org>
	<535ACB0E.4070600@infradead.org>
	<20140427062650.GW4496@linux.vnet.ibm.com>
	<20140428135540.GA14661@linux.vnet.ibm.com>
	<535E8D14.7080405@infradead.org>
	<535E8E17.2050600@nod.at>
	<20140428200640.GG4430@linux.vnet.ibm.com>
	<20140428213909.GA16623@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 14:39:09 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Mon, Apr 28, 2014 at 01:06:40PM -0700, Paul E. McKenney wrote:
> > On Mon, Apr 28, 2014 at 07:21:27PM +0200, Richard Weinberger wrote:
> > > Am 28.04.2014 19:17, schrieb Randy Dunlap:
> > > > 
> > > > uml defconfig on x86_64:
> > > > 
> > > >   CC      arch/um/kernel/asm-offsets.s
> > > > In file included from include/linux/sem.h:5:0,
> > > >                  from include/linux/sched.h:35,
> > > >                  from arch/x86/um/shared/sysdep/kernel-offsets.h:2,
> > > >                  from arch/um/kernel/asm-offsets.c:1:
> > > > include/linux/rcupdate.h:257:20: error: static declaration of 'rcu_sysrq_start' follows non-static declaration
> > > > include/linux/rcupdate.h:250:6: note: previous declaration of 'rcu_sysrq_start' was here
> > > > include/linux/rcupdate.h:260:20: error: static declaration of 'rcu_sysrq_end' follows non-static declaration
> > > > include/linux/rcupdate.h:251:6: note: previous declaration of 'rcu_sysrq_end' was here
> > > > make[2]: *** [arch/um/kernel/asm-offsets.s] Error 1
> > > > 
> > > > 
> > > > Please test your patch(es).
> > 
> > Against exactly what?  ;-)
> > 
> > > Just in case, to build an x86_64 UML please run:
> > > 
> > > make defconfig ARCH=um SUBARCH=x86_64
> > > make linux ARCH=um SUBARCH=x86_64
> > 
> > Hmmm....  Builds without errors in my local tree.
> > 
> > Make a clone of linux-next...
> > 
> > OK, now I get a different build failure:
> > 

OK, my tiny brain just burst.  Rik, I think I shall ease

sysrq-rcu-ify-__handle_sysrq.patch
sysrq-rcu-ify-__handle_sysrq-fix.patch
and
sysrqrcu-suppress-rcu-stall-warnings-while-sysrq-runs.patch

into the bitbucket for now.  Please resend everything when it's all
sorted out?
