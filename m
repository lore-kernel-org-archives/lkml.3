Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaFSEUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 00:20:06 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41229 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaFSEUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 00:20:04 -0400
Date: Wed, 18 Jun 2014 21:19:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140619041951.GE4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53A0CAE5.9000702@intel.com>
 <20140618001836.GV4669@linux.vnet.ibm.com>
 <53A132D4.60408@intel.com>
 <20140618125831.GB4669@linux.vnet.ibm.com>
 <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com>
 <20140619021337.GA4669@linux.vnet.ibm.com>
 <1403146219.5189.4.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403146219.5189.4.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061904-1344-0000-0000-0000024AD84C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 04:50:19AM +0200, Mike Galbraith wrote:
> On Wed, 2014-06-18 at 19:13 -0700, Paul E. McKenney wrote: 
> > On Wed, Jun 18, 2014 at 06:42:00PM -0700, Andi Kleen wrote:
> > > 
> > > I still think it's totally the wrong direction to pollute so 
> > > many fast paths with this obscure debugging check workaround
> > > unconditionally.
> > 
> > OOM prevention should count for something, I would hope.
> > 
> > > cond_resched() is in EVERY sleeping lock and in EVERY memory allocation!
> > > And these are really critical paths for many workloads.
> > > 
> > > If you really wanted to do this I think you would first need
> > > to define a cond_resched_i_am_not_fast() or somesuch.
> > > 
> > > Or put it all behind some debugging ifdef.
> > 
> > My first thought was to put it behind CONFIG_NO_HZ_FULL, but everyone
> > seems to be enabling that one.
> 
> Not everybody, SUSE doesn't even have it enabled in factory.

OK, apologies for the over-generalization.

But you would think that I would have learned this lesson with
CONFIG_RCU_FAST_NO_HZ, wouldn't you?  :-/

							Thanx, Paul

