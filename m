Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbaFSSJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:09:42 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41513 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531AbaFSSJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:09:40 -0400
Date: Thu, 19 Jun 2014 11:09:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140619180916.GE4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
 <20140618001836.GV4669@linux.vnet.ibm.com>
 <53A132D4.60408@intel.com>
 <20140618125831.GB4669@linux.vnet.ibm.com>
 <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com>
 <alpine.DEB.2.11.1406190941180.2785@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406190941180.2785@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061918-0928-0000-0000-000002C46C25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:42:18AM -0500, Christoph Lameter wrote:
> On Wed, 18 Jun 2014, Andi Kleen wrote:
> 
> > I still think it's totally the wrong direction to pollute so
> > many fast paths with this obscure debugging check workaround
> > unconditionally.
> >
> > cond_resched() is in EVERY sleeping lock and in EVERY memory allocation!
> > And these are really critical paths for many workloads.
> >
> > If you really wanted to do this I think you would first need
> > to define a cond_resched_i_am_not_fast() or somesuch.
> >
> > Or put it all behind some debugging ifdef.
> 
> Again I am fully on Andi's side here. Please remove these frequent calls
> to cond_resched. If one wants a fully preemptable kernel then please use
> CONFIG_PREEMPT.

That is a separate issue, but unnecessary calls to cond_resched()
should of course be removed -- no argument there.

							Thanx, Paul

