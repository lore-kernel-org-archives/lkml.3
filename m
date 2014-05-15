Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaEOTTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:19:44 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:50958 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaEOTTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:19:41 -0400
Date: Thu, 15 May 2014 15:19:38 -0400
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/3] CPU hotplug, smp: Flush any pending IPI callbacks
 before CPU offline
Message-ID: <20140515191938.GB21306@htj.dyndns.org>
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com>
 <20140515191358.19811.70381.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515191358.19811.70381.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, May 16, 2014 at 12:44:13AM +0530, Srivatsa S. Bhat wrote:
>  /*
> + * flush_smp_call_function_queue - Flush any pending smp-call-function

Don't we need a blank line here?

> + * callbacks queued on this CPU (including those for which the source CPU's
> + * IPIs might not have been received on this CPU yet). This is invoked by a
> + * CPU about to go offline, to ensure that all pending IPI functions are run
> + * before it goes completely offline.
> + *
> + * Loop through the call_single_queue and run all the queued functions.
> + * Must be called with interrupts disabled.
> + */

Other than that, looks good to me.

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
