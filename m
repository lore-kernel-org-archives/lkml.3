Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966438AbaFRM4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:56:22 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41795 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966138AbaFRM4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:56:21 -0400
Date: Wed, 18 Jun 2014 05:56:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>,
        peterz@infradead.org
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140618125614.GA4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <539B594C.8070004@intel.com>
 <20140613224519.GV4581@linux.vnet.ibm.com>
 <53A0CAE5.9000702@intel.com>
 <20140618001517.GL8178@tassilo.jf.intel.com>
 <20140618010423.GW4669@linux.vnet.ibm.com>
 <20140618022731.GM8178@tassilo.jf.intel.com>
 <20140618044745.GZ4669@linux.vnet.ibm.com>
 <20140618124028.GN8178@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140618124028.GN8178@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061812-1542-0000-0000-000002A7F803
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 05:40:28AM -0700, Andi Kleen wrote:
> On Tue, Jun 17, 2014 at 09:47:45PM -0700, Paul E. McKenney wrote:
> > On Tue, Jun 17, 2014 at 07:27:31PM -0700, Andi Kleen wrote:
> > > > OK.  What would you suggest instead?  If all we do is to revert the
> > > 
> > > Hang checker should have two timer phases:
> > > 
> > > Timer fires first time:
> > > - Save context switch counter on that. Force a reschedule to some
> > > work queue. Rearm timer
> > > 
> > > Timer fires again:
> > > - Check reschedule count. If the reschedule count changed
> > > it was a real hang, otherwise ignore.
> > 
> > I could take that approach, but the RT guys aren't going to thank me for
> > the wakeup associated with the work queue.  I suppose that I could use
> 
> They can disable the hang timer if it's really problem.
> 
> If they cannot tolerate a single context switch they likely 
> cannot tolerate a timer firing either.

Ah, but I make the timer fire on some other CPU.

							Thanx, Paul

