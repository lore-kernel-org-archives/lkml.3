Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbaDNQcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:32:14 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45557 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaDNQcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:32:10 -0400
Date: Mon, 14 Apr 2014 09:32:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kernel/rcu/tree.c: remove duplicate extern definition
Message-ID: <20140414163207.GG4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJhHMCBVQTpDecjd5sVhCWJk++K_Rne0DfHRoF7aSd7SRYp1WA@mail.gmail.com>
 <20140414160743.GF4496@linux.vnet.ibm.com>
 <CAJhHMCB5_A8xRHAnpQuTTcc4KhXEiS5Uo+oZEih=cci9H+H79w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJhHMCB5_A8xRHAnpQuTTcc4KhXEiS5Uo+oZEih=cci9H+H79w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041416-0928-0000-0000-0000012578AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 12:19:31PM -0400, Pranith Kumar wrote:
> Hi Paul,
> 
> On Mon, Apr 14, 2014 at 12:07 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Sun, Apr 13, 2014 at 05:53:53PM -0400, Pranith Kumar wrote:
> >> remove duplicate definition of extern resched_cpu
> >>
> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> >
> > Hello, Pranith,
> >
> > When I apply this patch I get the following:
> >
> > /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c: In function ‘rcu_implicit_dynticks_qs’:
> > /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:895:3: error: implicit declaration of function ‘resched_cpu’ [-Werror=implicit-function-declaration]
> > /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c: At top level:
> > /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:1009:13: warning: conflicting types for ‘resched_cpu’ [enabled by default]
> > /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:895:3: note: previous implicit declaration of ‘resched_cpu’ was here
> >
> > This failed in under number of different Kconfig setups, the .config file
> > for one of them is attached.
> >
> > So this declaration really is needed.  Just out of curiosity, what led
> > you to believe that it could be removed?
> >
> 
> That is strange. The patch removes a duplicate declaration of
> resched_cpu (on lines 768, 954) of the file kernel/rcu/tree.c of the
> latest git.
> 
> The patch compiles fine here with the latest tip of the git tree.
> 
>   CC      kernel/rcu/tree.o
> 
> Can you please check if your tree.c has two declarations for resched_cpu?

Ah, your patch didn't apply, so I hand-applied it, and removed the first
declaration rather than the second one.  Trying it again.

							Thanx, Paul

