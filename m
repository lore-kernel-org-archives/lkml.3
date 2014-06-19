Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbaFSFXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:23:44 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52564 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaFSFXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:23:43 -0400
Date: Wed, 18 Jun 2014 22:23:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140619052337.GG4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140618001836.GV4669@linux.vnet.ibm.com>
 <53A132D4.60408@intel.com>
 <20140618125831.GB4669@linux.vnet.ibm.com>
 <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com>
 <20140619021337.GA4669@linux.vnet.ibm.com>
 <20140619033816.GQ8178@tassilo.jf.intel.com>
 <1403153545.1225.8.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403153545.1225.8.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061905-1344-0000-0000-0000024AFD53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 09:52:25PM -0700, Eric Dumazet wrote:
> On Wed, 2014-06-18 at 20:38 -0700, Andi Kleen wrote:
> > On Wed, Jun 18, 2014 at 07:13:37PM -0700, Paul E. McKenney wrote:
> > > On Wed, Jun 18, 2014 at 06:42:00PM -0700, Andi Kleen wrote:
> > > > 
> > > > I still think it's totally the wrong direction to pollute so 
> > > > many fast paths with this obscure debugging check workaround
> > > > unconditionally.
> > > 
> > > OOM prevention should count for something, I would hope.
> > 
> > OOM in what scenario? This is getting bizarre.
> > 
> > If something keeps looping forever in the kernel creating 
> > RCU callbacks without any real quiescent states it's simply broken.
> 
> Typical problem we faced in the past is in exit() path when multi
> thousands of files/sockets are rcu-freed, and qhimark is hit.
> 
> Huge latency alerts, as freeing 10000+ items takes a while (about 70 ns
> per item...)
> 
> Maybe close_files() should use a
> cond_resched_and_keep_rcu_queues_small_please() ;)

That sort of approach would work for me.  Over time, I would guess
that the cond_resched_and_keep_rcu_queues_small_please() function would
find its way to where it needed to be.  ;-)

							Thanx, Paul

