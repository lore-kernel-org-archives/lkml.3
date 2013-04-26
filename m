Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3DZQWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 12:22:21 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:46001 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3DZQWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 12:22:20 -0400
Date: Fri, 26 Apr 2013 18:22:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Hakan Akkan <hakanakkan@gmail.com>,
        Kevin Hilman <khilman@linaro.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] nohz: Select VIRT_CPU_ACCOUNTING_GEN from full
 dynticks config
Message-ID: <20130426162214.GB30716@somewhere>
References: <1366988007-30665-1-git-send-email-fweisbec@gmail.com>
 <1366988007-30665-2-git-send-email-fweisbec@gmail.com>
 <20130426153956.GB3860@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426153956.GB3860@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 08:39:56AM -0700, Paul E. McKenney wrote:
> >  config VIRT_CPU_ACCOUNTING_GEN
> >  	bool "Full dynticks CPU time accounting"
> > -	depends on HAVE_CONTEXT_TRACKING && 64BIT
> > +	depends on HAVE_CONTEXT_TRACKING && 64BIT && NO_HZ_FULL
> 
> Do you really want this change?  This prohibits VIRT_CPU_ACCOUNTING_GEN
> unless NO_HZ_FULL, which means that it can no longer be used in situations
> where it used to be usable.  My guess is that you want to leave this
> particular line as it was.

Hmm, this can make sense. This can be used to perform comparisons between
tick-based and tickless cputime accounting easily.

I'll respin.
