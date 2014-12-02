Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbaLBTLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:11:48 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47943 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073AbaLBTLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:11:47 -0500
Date: Tue, 2 Dec 2014 11:11:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141202191143.GN25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <20141201230813.GE25340@linux.vnet.ibm.com>
 <547dec29.c71f8c0a.33d1.11d9@mx.google.com>
 <20141202170407.GK25340@linux.vnet.ibm.com>
 <547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
 <20141202184202.GM25340@linux.vnet.ibm.com>
 <547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120219-0013-0000-0000-000006B40B94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 04:47:31PM -0200, Dâniel Fraga wrote:
> On Tue, 2 Dec 2014 10:42:02 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > I was actually suggesting something a bit different.  Instead of bisecting
> > by release, bisect by code.  The procedure is as follows:
> > 
> > 1.	I figure out some reliable way of making RCU allow preemption to
> > 	be disabled for some RCU read-side critical sections, but not for
> > 	others.  I send you the patch, which has rcu_read_lock_test()
> > 	as well as rcu_read_lock().
> > 
> > 2.	You build a kernel without my Kconfig hack, with my patch from
> > 	#1 above, and build a kernel with CONFIG_PREEMPT=y (which of
> > 	course implies CONFIG_TREE_PREEMPT_RCU=y, given that you are
> > 	building without my Kconfig hack).
> > 
> > 3.	You make a list of all the rcu_read_lock() uses in the kernel
> > 	(or ask me to provide it).  You change the rcu_read_lock()
> > 	calls in the first half of this list to rcu_read_lock_test().
> > 
> > 	If the kernel locks up as easily with this change as it did
> > 	in a stock CONFIG_PREEMPT=y CONFIG_TREE_PREEMPT_RCU=y kernel,
> > 	change half of the remaining rcu_read_lock() calls to
> > 	rcu_read_lock_test().  If the kernel is much more resistant
> > 	to lockup, change half of the rcu_read_lock_test() calls
> > 	back to rcu_read_lock().
> 
> 	Ok Paul, I want to do everything I can to help you debug this.
> 
> 	So can you provide me the list you mentioned at point 3 (or
> tell me how can I get it)? If you guide me through this, I can do
> whatever you need. Thanks!

OK.  I need to know exactly what version of the Linux kernel you are
using.  3.18-rc7?  (I am not too worried about exactly which version
you are using as long as I know which version it is.)

							Thanx, Paul

