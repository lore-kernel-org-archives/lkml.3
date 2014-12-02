Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbaLBSri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:47:38 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:42807 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbaLBSrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:47:37 -0500
Message-ID: <547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
Date: Tue, 2 Dec 2014 16:47:31 -0200
From: =?UTF-8?B?RMOibmllbA==?= Fraga <fragabr@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <20141202184202.GM25340@linux.vnet.ibm.com>
References: <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<20141201230813.GE25340@linux.vnet.ibm.com>
	<547dec29.c71f8c0a.33d1.11d9@mx.google.com>
	<20141202170407.GK25340@linux.vnet.ibm.com>
	<547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
	<20141202184202.GM25340@linux.vnet.ibm.com>
Organization: http://www.youtube.com/DanielFragaBR
X-Mailer: Claws Mail 3.11.1-9-g1f531c (GTK+ 2.24.25; x86_64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2014 10:42:02 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> I was actually suggesting something a bit different.  Instead of bisecting
> by release, bisect by code.  The procedure is as follows:
> 
> 1.	I figure out some reliable way of making RCU allow preemption to
> 	be disabled for some RCU read-side critical sections, but not for
> 	others.  I send you the patch, which has rcu_read_lock_test()
> 	as well as rcu_read_lock().
> 
> 2.	You build a kernel without my Kconfig hack, with my patch from
> 	#1 above, and build a kernel with CONFIG_PREEMPT=y (which of
> 	course implies CONFIG_TREE_PREEMPT_RCU=y, given that you are
> 	building without my Kconfig hack).
> 
> 3.	You make a list of all the rcu_read_lock() uses in the kernel
> 	(or ask me to provide it).  You change the rcu_read_lock()
> 	calls in the first half of this list to rcu_read_lock_test().
> 
> 	If the kernel locks up as easily with this change as it did
> 	in a stock CONFIG_PREEMPT=y CONFIG_TREE_PREEMPT_RCU=y kernel,
> 	change half of the remaining rcu_read_lock() calls to
> 	rcu_read_lock_test().  If the kernel is much more resistant
> 	to lockup, change half of the rcu_read_lock_test() calls
> 	back to rcu_read_lock().

	Ok Paul, I want to do everything I can to help you debug this.

	So can you provide me the list you mentioned at point 3 (or
tell me how can I get it)? If you guide me through this, I can do
whatever you need. Thanks!

-- 
Linux 3.17.0-rc6-00235-gb94d525: Shuffling Zombie Juror
http://www.youtube.com/DanielFragaBR
http://exchangewar.info
Bitcoin: 12H6661yoLDUZaYPdah6urZS5WiXwTAUgL
