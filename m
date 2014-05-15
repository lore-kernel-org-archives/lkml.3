Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbaEOThH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:37:07 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51841 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbaEOThF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:37:05 -0400
Date: Thu, 15 May 2014 12:36:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, peterz@infradead.org, tglx@linutronix.de,
        mingo@kernel.org, rusty@rustcorp.com.au, akpm@linux-foundation.org,
        fweisbec@gmail.com, hch@infradead.org, mgorman@suse.de,
        riel@redhat.com, bp@suse.de, rostedt@goodmis.org, mgalbraith@suse.de,
        ego@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] CPU hotplug, smp: Flush any pending IPI callbacks
 before CPU offline
Message-ID: <20140515193656.GM4570@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com>
 <20140515191358.19811.70381.stgit@srivatsabhat.in.ibm.com>
 <20140515191938.GB21306@htj.dyndns.org>
 <537514D3.4060308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537514D3.4060308@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051519-0928-0000-0000-000001EADA44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 12:56:11AM +0530, Srivatsa S. Bhat wrote:
> On 05/16/2014 12:49 AM, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, May 16, 2014 at 12:44:13AM +0530, Srivatsa S. Bhat wrote:
> >>  /*
> >> + * flush_smp_call_function_queue - Flush any pending smp-call-function
> > 
> > Don't we need a blank line here?
> 
> Hmm? That sentence continues on the next line, hence I didn't add any blank
> line there.

Tejun might be wanting this to be a docbook comment, in which case
it also needs "/**" at the beginning of the comment.

							Thanx, Paul

> >> + * callbacks queued on this CPU (including those for which the source CPU's
> >> + * IPIs might not have been received on this CPU yet). This is invoked by a
> >> + * CPU about to go offline, to ensure that all pending IPI functions are run
> >> + * before it goes completely offline.
> >> + *
> >> + * Loop through the call_single_queue and run all the queued functions.
> >> + * Must be called with interrupts disabled.
> >> + */
> > 
> > Other than that, looks good to me.
> > 
> > Reviewed-by: Tejun Heo <tj@kernel.org>
> > 
> 
> Thank you!
> 
> Regards,
> Srivatsa S. Bhat
> 

