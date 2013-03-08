Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905Ab3CHI0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 03:26:22 -0500
Received: from mout.gmx.net ([212.227.15.15]:62773 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab3CHI0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 03:26:22 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+9+m9YexG92jYx7KIDrlXEBEk5oOGju+A9z6TEoW
	/v5uLx2QcEzZrH
Message-ID: <1362731173.31859.81.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: wakeup buddy
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Fri, 08 Mar 2013 09:26:13 +0100
In-Reply-To: <5139938A.1040504@linux.vnet.ibm.com>
References: <5136EB06.2050905@linux.vnet.ibm.com>
	 <1362645372.2606.11.camel@laptop>
	 <1362649419.4652.12.camel@marge.simpson.net>
	 <51394EE3.1020706@linux.vnet.ibm.com>
	 <1362725051.31859.40.camel@marge.simpson.net>
	 <5139938A.1040504@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-08 at 15:30 +0800, Michael Wang wrote: 
> On 03/08/2013 02:44 PM, Mike Galbraith wrote:

> > In general, I think things would work better if we'd just rate limit how
> > frequently we can wakeup migrate each individual task.  
> 
> Isn't the wakeup buddy already limit the rate? and by turning the knob,
> we could change the rate on our demand.

I was referring to the existing kernel, not as altered. 

> We want
> > jabbering tasks to share L3, but we don't really want to trash L2 at an
> > awesome rate.
> 
> I don't get it..., it's a task which has 'sleep' for some time, unless
> there is no task running on prev_cpu when it's sleeping, otherwise
> whatever the new cpu is, we will trash L2, isn't it?

I'm thinking if you wake it to it's old home after a microscopic sleep,
it has a good chance of evicting the current resident, rescuing its L2.
If tasks which do microscopic sleep can't move around at a high rate,
they'll poke holes in fewer preempt victims.  If they're _really_ fast
switchers, always wake affine.  They can't hurt much, they don't do much
other than schedule off.

-Mike

