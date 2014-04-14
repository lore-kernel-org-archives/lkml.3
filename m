Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaDNRbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:31:31 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50643 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbaDNRbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:31:04 -0400
Date: Mon, 14 Apr 2014 10:31:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kernel/rcu/tree.c: remove duplicate extern definition
Message-ID: <20140414173100.GI4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJhHMCBVQTpDecjd5sVhCWJk++K_Rne0DfHRoF7aSd7SRYp1WA@mail.gmail.com>
 <20140414160743.GF4496@linux.vnet.ibm.com>
 <CAJhHMCB5_A8xRHAnpQuTTcc4KhXEiS5Uo+oZEih=cci9H+H79w@mail.gmail.com>
 <CAJhHMCCX=DdCpDsakJVhRat7-iieqT2_65vfxBjy7C-bSPc8VQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJhHMCCX=DdCpDsakJVhRat7-iieqT2_65vfxBjy7C-bSPc8VQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041417-1344-0000-0000-000000E966BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 12:27:47PM -0400, Pranith Kumar wrote:
> On Mon, Apr 14, 2014 at 12:19 PM, Pranith Kumar <pranith@gatech.edu> wrote:
> > Hi Paul,
> >
> > On Mon, Apr 14, 2014 at 12:07 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> >> On Sun, Apr 13, 2014 at 05:53:53PM -0400, Pranith Kumar wrote:
> >>> remove duplicate definition of extern resched_cpu
> >>>
> >>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >>
> >> Hello, Pranith,
> >>
> >> When I apply this patch I get the following:
> >>
> >> /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c: In function ‘rcu_implicit_dynticks_qs’:
> >> /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:895:3: error: implicit declaration of function ‘resched_cpu’ [-Werror=implicit-function-declaration]
> >> /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c: At top level:
> >> /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:1009:13: warning: conflicting types for ‘resched_cpu’ [enabled by default]
> >> /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:895:3: note: previous implicit declaration of ‘resched_cpu’ was here
> >>
> >> This failed in under number of different Kconfig setups, the .config file
> >> for one of them is attached.
> >>
> >> So this declaration really is needed.  Just out of curiosity, what led
> >> you to believe that it could be removed?
> >>
> 
> Your attached config has the following:
> 
> Linux/x86 3.14.0-rc3 Kernel Configuration
> 
> The patch is against 3.15.0-rc1 (the latest at this time). May be that
> is the reason?

Nope, it was just me messing up when hand-applying the patch.  The reason
the patch wouldn't apply is that I am working against the -rcu tree at
git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git,
branch rcu/dev.  Once I applied it correctly, removing the second of
the two declarations rather than the first one, it worked fine.

So please accept my apologies for my confusion.  I have queued your
patch for 3.16, thank you!

							Thanx, Paul

