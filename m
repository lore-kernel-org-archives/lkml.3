Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932986AbaLDSCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:02:23 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43446 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932382AbaLDSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:02:20 -0500
Date: Thu, 4 Dec 2014 10:02:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [RFC PATCH v2] tinification: Introduce CONFIG_SRCU to make SRCU
 optional
Message-ID: <20141204180210.GS25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1417665832-6933-1-git-send-email-bobby.prani@gmail.com>
 <20141204062704.GH25340@linux.vnet.ibm.com>
 <54807FC3.9050305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54807FC3.9050305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120418-0005-0000-0000-000006DC5875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:37:39AM -0500, Pranith Kumar wrote:
> On 12/04/2014 01:27 AM, Paul E. McKenney wrote:
> > For the moment, I applied this to -rcu against v3.18-rc6 to get some 0day
> > testing on it.
> > 
> > There are conflicts against the tip of my tree, but will worry about
> > that later.  I don't have a ready answer on whether or not this needs
> > to be split up -- in the worst case, we would add the SRCU Kconfig
> > parameter, add all the selects, then once they all hit mainline add the
> > Makefile change.
> > 
> > We will need stats on how much memory was saved, and a "size kernel/rcu/srcu.o"
> > after a UP/tiny build should do it.  Could you please add this to the
> > commit log?
> > 
> 
> So if we do not select CONFIG_SRCU, srcu.o will not be compiled at all. So we should save about
> 
>    text	   data	    bss	    dec	    hex	filename
>    2007	      0	      0	   2007	    7d7	kernel/rcu/srcu.o
> 
> as in size of arch/powerpc/boot/zImage changes from
> 
>    text	   data	    bss	    dec	    hex	filename
>  831552	  64180	  23944	 919676	  e087c	arch/powerpc/boot/zImage : before
>  829504	  64180	  23952	 917636	  e0084	arch/powerpc/boot/zImage : after
> 
> so about ~2000 bytes I guess. 

Nice!

Josh, I recall you having a tinified .config somewhere, but don't see it
right off.  If you do have one, could you please share it with Pranith?
Not a big deal, just don't want to overstate the savings too much.  ;-)

							Thanx, Paul

