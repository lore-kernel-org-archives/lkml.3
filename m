Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674Ab3DYVXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:23:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35026 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758891Ab3DYVXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:23:44 -0400
Date: Thu, 25 Apr 2013 14:23:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, sbw@mit.edu, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>,
        Olivier Baetz <olivier.baetz@novasparks.com>
Subject: Re: [PATCH documentation 2/2] kthread: Document ways of reducing OS
 jitter due to per-CPU kthreads
Message-ID: <20130425212336.GN3427@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130416164036.GA27246@linux.vnet.ibm.com>
 <1366130490-27584-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1366130490-27584-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130421193705.GB5807@pd.tnic>
 <20130423040329.GP3509@linux.vnet.ibm.com>
 <20130425102311.GA32607@pd.tnic>
 <20130425155215.GK3427@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1304252257140.21884@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1304252257140.21884@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042521-3620-0000-0000-0000023173AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 10:59:05PM +0200, Thomas Gleixner wrote:
> On Thu, 25 Apr 2013, Paul E. McKenney wrote:
> > On Thu, Apr 25, 2013 at 12:23:12PM +0200, Borislav Petkov wrote:
> > > On Mon, Apr 22, 2013 at 09:03:29PM -0700, Paul E. McKenney wrote:
> > > > > > +Name: ehca_comp/%u
> > > > > > +Purpose: Periodically process Infiniband-related work.
> > > > > > +To reduce corresponding OS jitter, do any of the following:
> > > > > > +1.	Don't use EHCA Infiniband hardware.  This will prevent these
> > > > > 
> > > > > Sounds like this particular hardware is slow and its IRQ handler/softirq
> > > > > needs a lot of time. Yes, no?
> > > > > 
> > > > > Can we have a reason why people shouldn't use that hw.
> > > > 
> > > > Because it has per-CPU kthreads that can cause OS jitter.  ;-)
> > > 
> > > Yeah, I stumbled over this specific brand of Infiniband hw. It looks
> > > like this particular Infiniband driver uses per-CPU kthreads and the
> > > others in drivers/infiniband/hw/ don't?
> > > 
> > > I hope this explains my head-scratching moment here...
> > 
> > Ah!  I rewrote the first sentence to read:
> > 
> > 	Don't use eHCA Infiniband hardware, instead choosing hardware
> > 	that does not require per-CPU kthreads.
> 
> Another option would be to teach that eHCA driver to be configurable
> on which cpus kthreads are desired and on which not. I can't see a
> reason (aside of throughput) why that hardware can't cope with a
> single thread.

Good point!  I have added a third item to the eHCA list:

	Rework the eHCA driver so that its per-CPU kthreads are
	provisioned only on selected CPUs.

							Thanx, Paul

