Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966458AbaFRMka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:40:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:15788 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966138AbaFRMk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:40:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,499,1400050800"; 
   d="scan'208";a="559536616"
Date: Wed, 18 Jun 2014 05:40:28 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>,
        peterz@infradead.org
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140618124028.GN8178@tassilo.jf.intel.com>
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
 <20140618001517.GL8178@tassilo.jf.intel.com>
 <20140618010423.GW4669@linux.vnet.ibm.com>
 <20140618022731.GM8178@tassilo.jf.intel.com>
 <20140618044745.GZ4669@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618044745.GZ4669@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 09:47:45PM -0700, Paul E. McKenney wrote:
> On Tue, Jun 17, 2014 at 07:27:31PM -0700, Andi Kleen wrote:
> > > OK.  What would you suggest instead?  If all we do is to revert the
> > 
> > Hang checker should have two timer phases:
> > 
> > Timer fires first time:
> > - Save context switch counter on that. Force a reschedule to some
> > work queue. Rearm timer
> > 
> > Timer fires again:
> > - Check reschedule count. If the reschedule count changed
> > it was a real hang, otherwise ignore.
> 
> I could take that approach, but the RT guys aren't going to thank me for
> the wakeup associated with the work queue.  I suppose that I could use

They can disable the hang timer if it's really problem.

If they cannot tolerate a single context switch they likely 
cannot tolerate a timer firing either.

-Andi
