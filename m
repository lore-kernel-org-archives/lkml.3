Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422672AbaDPQGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:06:30 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48792 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422635AbaDPQG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:06:26 -0400
Date: Wed, 16 Apr 2014 09:06:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tj@kernel.org,
        grygorii.strashko@ti.com, peterz@infradead.org
Subject: Re: How do I increment a per-CPU variable without warning?
Message-ID: <20140416160621.GX4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140415221755.GA27188@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1404161007080.9945@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404161007080.9945@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041616-8236-0000-0000-0000019342A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:08:03AM -0500, Christoph Lameter wrote:
> On Tue, 15 Apr 2014, Paul E. McKenney wrote:
> 
> > Hello, Christoph,
> >
> > I have a patch that currently uses __this_cpu_inc_return() to increment a
> > per-CPU variable, but without preemption disabled.  Of course, given that
> > preemption is enabled, it might well end up picking up one CPU's counter,
> > adding one to it, then storing the result into some other CPU's counter.
> > But this is OK, the test can be probabilistic.  And when I run this
> > against v3.14 and earlier, it works fine.
> 
> We introduced raw_cpu_inc_return to squish these warnings.

Cool, this is a good short-term fix.

> > This is arguably better than the original __this_cpu_read() because it
> > avoids overflow, but I thought I should check to see if there was some
> > better way to do this.
> 
> If this is supposed to be totally race safe then you must disable
> preemption.

Understood!

							Thanx, Paul

