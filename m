Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaCPHaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 03:30:23 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:49580 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaCPHaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 03:30:22 -0400
Message-ID: <1394955020.19079.3.camel@marge.simpson.net>
Subject: Re: cond_resched() and RCU CPU stall warnings
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: peterz@infradead.org, mingo@elte.hu, josh@joshtriplett.org,
        laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Date: Sun, 16 Mar 2014 08:30:20 +0100
In-Reply-To: <20140316062501.GX21124@linux.vnet.ibm.com>
References: <20140316015914.GA22102@linux.vnet.ibm.com>
	 <1394950182.5470.15.camel@marge.simpson.net>
	 <20140316062501.GX21124@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-03-15 at 23:25 -0700, Paul E. McKenney wrote: 
> On Sun, Mar 16, 2014 at 07:09:42AM +0100, Mike Galbraith wrote:

> > Hm.  Since you only care about the case where your task is solo, how
> > about do racy checks, 100% accuracy isn't required is it?  Seems you
> > wouldn't want to unconditionally do that in tight loops.
> 
> And indeed, my current workaround unconditionally does schedule() one
> out of 256 loops.  I would do something similar here, perhaps based
> on per-CPU counters, perhaps even with racy accesses to avoid always
> doing preempt_disable()/preempt_enable().
> 
> Or did you have something else in mind?

Exactly what I meant, take a racy peek or two first.

-Mike

