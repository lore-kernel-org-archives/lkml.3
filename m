Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaDQRxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:53:38 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:44278
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbaDQRxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:53:30 -0400
Date: Thu, 17 Apr 2014 12:53:28 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tj@kernel.org,
        grygorii.strashko@ti.com, peterz@infradead.org
Subject: Re: How do I increment a per-CPU variable without warning?
In-Reply-To: <20140417174615.GO4496@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.10.1404171250190.28585@gentwo.org>
References: <20140415221755.GA27188@linux.vnet.ibm.com> <alpine.DEB.2.10.1404161007080.9945@gentwo.org> <20140416160621.GX4496@linux.vnet.ibm.com> <20140416171230.GA8788@linux.vnet.ibm.com> <alpine.DEB.2.10.1404161328410.21030@gentwo.org>
 <20140416184755.GY4496@linux.vnet.ibm.com> <alpine.DEB.2.10.1404171235480.28251@gentwo.org> <20140417174615.GO4496@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014, Paul E. McKenney wrote:

> Fair enough!  I resent the patch with your Ack to Tejun.

Also note that you may want to use

	this_cpu_inc

instead of raw_cpu_inc.

this_cpu_inc will not disable preemption or anything on x86 but just
create a single instruction using instruction atomicity to avoid the
preempt on/off sequence.


On platforms that cannot emit such an instruction it will fallback to
disable interrupts for the sequence of instructions that increments the
value.

With such an approach incrementing the counter should be much safer. If
the other arch want to avoid irq on/off sequences then they can override
the fallback to use atomics or whatever the processor architecture permits
to avoid the overhead of interrupt on / off.



