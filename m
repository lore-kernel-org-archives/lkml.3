Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbaLATOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:14:42 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:49888 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932254AbaLATOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:14:39 -0500
Date: Mon, 1 Dec 2014 11:14:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141201191431.GA17385@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>
 <20141126024032.GA13246@redhat.com>
 <20141126225745.GA30346@redhat.com>
 <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
 <20141127225637.GA24019@redhat.com>
 <m5dart$co$1@ger.gmane.org>
 <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
 <547b8a45.6e608c0a.20f9.1002@mx.google.com>
 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547bbe36.48548c0a.105c.779c@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120119-0025-0000-0000-00000687BFFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 11:02:43PM -0200, Dâniel Fraga wrote:
> On Sun, 30 Nov 2014 16:21:19 -0800
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Maybe you'll have to turn off RCU_CPU_STALL_VERBOSE first.
> > 
> > Although I think you should be able to just edit the .config file,
> > delete the like that says
> > 
> >     CONFIG_TREE_PREEMPT_RCU=y
> > 
> > and then just do a "make oldconfig", and then verify that
> > TREE_PREEMPT_RCU hasn't been re-enabled by some dependency. But it
> > shouldn't have, and that "make oldconfig" should get rid of anything
> > that depends on TREE_PREEMPT_RCU.
> 	
> 	Ok, I did exactly that, but CONFIG_TREE_PREEMPT_RCU is
> re-enabled. I talked with Pranith Kumar and he suggested I could just
> disable preemption (No Forced Preemption (Server)) and that's the only
> way to disable CONFIG_TREE_PREEMPT_RCU.

If it would help to have !CONFIG_TREE_PREEMPT_RCU with CONFIG_PREEMPT=y,
please let me know and I will create a patch that forces this.
(Not mainline material, but if it helps with debug...)

							Thanx, Paul

> 	Now I'll try to make the system freeze, then I'll send
> you the Call trace.
> 
> 	Thanks.
> 
> -- 
> Linux 3.17.0: Shuffling Zombie Juror
> http://www.youtube.com/DanielFragaBR
> http://exchangewar.info
> Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

