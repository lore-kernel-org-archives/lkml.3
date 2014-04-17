Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaDQSVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:21:22 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50507 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaDQSVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:21:11 -0400
Date: Thu, 17 Apr 2014 11:21:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tj@kernel.org,
        grygorii.strashko@ti.com, peterz@infradead.org
Subject: Re: How do I increment a per-CPU variable without warning?
Message-ID: <20140417182106.GP4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140415221755.GA27188@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1404161007080.9945@gentwo.org>
 <20140416160621.GX4496@linux.vnet.ibm.com>
 <20140416171230.GA8788@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1404161328410.21030@gentwo.org>
 <20140416184755.GY4496@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1404171235480.28251@gentwo.org>
 <20140417174615.GO4496@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1404171250190.28585@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404171250190.28585@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041718-6688-0000-0000-0000012B3C9D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:53:28PM -0500, Christoph Lameter wrote:
> On Thu, 17 Apr 2014, Paul E. McKenney wrote:
> 
> > Fair enough!  I resent the patch with your Ack to Tejun.
> 
> Also note that you may want to use
> 
> 	this_cpu_inc
> 
> instead of raw_cpu_inc.
> 
> this_cpu_inc will not disable preemption or anything on x86 but just
> create a single instruction using instruction atomicity to avoid the
> preempt on/off sequence.
> 
> 
> On platforms that cannot emit such an instruction it will fallback to
> disable interrupts for the sequence of instructions that increments the
> value.
> 
> With such an approach incrementing the counter should be much safer. If
> the other arch want to avoid irq on/off sequences then they can override
> the fallback to use atomics or whatever the processor architecture permits
> to avoid the overhead of interrupt on / off.

Fair enough, but in this case I don't need it to be safe.

							Thanx, Paul

