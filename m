Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966127AbaFSXHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:07:37 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44333 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964958AbaFSXHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:07:36 -0400
Date: Thu, 19 Jun 2014 16:07:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: Christoph Lameter <cl@gentwo.org>, Andi Kleen <ak@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140619230732.GX4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com>
 <alpine.DEB.2.11.1406190941180.2785@gentwo.org>
 <20140619180916.GE4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191531020.4002@gentwo.org>
 <20140619204220.GJ4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191612000.5484@gentwo.org>
 <alpine.DEB.2.11.1406191614270.5484@gentwo.org>
 <20140619213203.GA16747@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619213203.GA16747@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061923-6688-0000-0000-000002AFC70D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 02:32:03PM -0700, josh@joshtriplett.org wrote:
> On Thu, Jun 19, 2014 at 04:16:34PM -0500, Christoph Lameter wrote:
> > This looks very much like the CONFIG_PREEMPT problem in not so
> > extreme form. Maybe we need to add another config option:
> > 
> > CONFIG_REALLY_REALLY_NO_PREEMPT
> > 
> > to get the fastest code possible and those cond_rescheds removed from the
> > critical paths?
> > 
> > Or better
> > 
> > CONFIG_PREEMPT_HALF_WAY
> > 
> > to enable those cond_rescheds.
> 
> That much actually does seem quite reasonable: making cond_resched() do
> non-trivial work ought to have a config option to disable it.

I am putting together patches based on Eric Dumazet's suggestion and on a
variant of the above approach.  However, I do expect the distros to starve
to death between those two bales of hay.  But perhaps the actual patches
will inspire a bit of light to go with this thread's heat and smoke.

							Thanx, Paul

