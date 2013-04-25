Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199Ab3DYU7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:59:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:46126 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab3DYU7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:59:14 -0400
Date: Thu, 25 Apr 2013 22:59:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, sbw@mit.edu, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@linaro.org>, Christoph Lameter <cl@linux.com>,
        Olivier Baetz <olivier.baetz@novasparks.com>
Subject: Re: [PATCH documentation 2/2] kthread: Document ways of reducing OS
 jitter due to per-CPU kthreads
In-Reply-To: <20130425155215.GK3427@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1304252257140.21884@ionos>
References: <20130416164036.GA27246@linux.vnet.ibm.com> <1366130490-27584-1-git-send-email-paulmck@linux.vnet.ibm.com> <1366130490-27584-2-git-send-email-paulmck@linux.vnet.ibm.com> <20130421193705.GB5807@pd.tnic> <20130423040329.GP3509@linux.vnet.ibm.com>
 <20130425102311.GA32607@pd.tnic> <20130425155215.GK3427@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Apr 2013, Paul E. McKenney wrote:
> On Thu, Apr 25, 2013 at 12:23:12PM +0200, Borislav Petkov wrote:
> > On Mon, Apr 22, 2013 at 09:03:29PM -0700, Paul E. McKenney wrote:
> > > > > +Name: ehca_comp/%u
> > > > > +Purpose: Periodically process Infiniband-related work.
> > > > > +To reduce corresponding OS jitter, do any of the following:
> > > > > +1.	Don't use EHCA Infiniband hardware.  This will prevent these
> > > > 
> > > > Sounds like this particular hardware is slow and its IRQ handler/softirq
> > > > needs a lot of time. Yes, no?
> > > > 
> > > > Can we have a reason why people shouldn't use that hw.
> > > 
> > > Because it has per-CPU kthreads that can cause OS jitter.  ;-)
> > 
> > Yeah, I stumbled over this specific brand of Infiniband hw. It looks
> > like this particular Infiniband driver uses per-CPU kthreads and the
> > others in drivers/infiniband/hw/ don't?
> > 
> > I hope this explains my head-scratching moment here...
> 
> Ah!  I rewrote the first sentence to read:
> 
> 	Don't use eHCA Infiniband hardware, instead choosing hardware
> 	that does not require per-CPU kthreads.

Another option would be to teach that eHCA driver to be configurable
on which cpus kthreads are desired and on which not. I can't see a
reason (aside of throughput) why that hardware can't cope with a
single thread.

Thanks,

	tglx
