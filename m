Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046AbaFSUur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:50:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:11721 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbaFSUuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:50:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,508,1400050800"; 
   d="scan'208";a="447687141"
Date: Thu, 19 Jun 2014 13:50:44 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@gentwo.org>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140619205044.GX8178@tassilo.jf.intel.com>
References: <53A132D4.60408@intel.com>
 <20140618125831.GB4669@linux.vnet.ibm.com>
 <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com>
 <alpine.DEB.2.11.1406190941180.2785@gentwo.org>
 <20140619180916.GE4904@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1406191531020.4002@gentwo.org>
 <20140619204220.GJ4904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619204220.GJ4904@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 01:42:20PM -0700, Paul E. McKenney wrote:
> On Thu, Jun 19, 2014 at 03:31:56PM -0500, Christoph Lameter wrote:
> > On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> > 
> > > That is a separate issue, but unnecessary calls to cond_resched()
> > > should of course be removed -- no argument there.
> > 
> > It looks like we are fighting higher latencies by adding calls in most of
> > the critical sections which will in turn increase the latencies that we
> > are trying to reduce.
> 
> That is on battle in a larger war.  Another battle is to keep big systems
> from choking and dying.  We need to win both battles, though I understand

If we really need cond_resched() now to stop systems from dying
we did a really poor job at designing Linux. I hope it's not true,
that would be really bad and point to some severe design problems
elsewhere.

-Andi

