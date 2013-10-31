Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3JaJFV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 05:05:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37808 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3JaJFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:05:20 -0400
Date: Thu, 31 Oct 2013 10:04:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Victor Kaplansky <VICTORK@il.ibm.com>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131031090457.GU19466@laptop.lan>
References: <20131025173749.GG19466@laptop.lan>
 <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <OFC6B7100E.31C6B190-ON42257C14.004841C6-42257C14.004A0EA6@il.ibm.com>
 <20131031043258.GQ4126@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131031043258.GQ4126@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 09:32:58PM -0700, Paul E. McKenney wrote:
> Before C/C++11, the closest thing to such a prohibition is use of
> volatile, for example, ACCESS_ONCE().  Even in C/C++11, you have to
> use atomics to get anything resembing this prohibition.
> 
> If you just use normal variables, the compiler is within its rights
> to transform something like the following:
> 
> 	if (a)
> 		b = 1;
> 	else
> 		b = 42;
> 
> Into:
> 
> 	b = 42;
> 	if (a)
> 		b = 1;
> 
> Many other similar transformations are permitted.  Some are used to all
> vector instructions to be used -- the compiler can do a write with an
> overly wide vector instruction, then clean up the clobbered variables
> later, if it wishes.  Again, if the variables are not marked volatile,
> or, in C/C++11, atomic.

While I've heard you tell this story before, my mind keeps boggling how
we've been able to use shared memory at all, all these years.

It seems to me stuff should have broken left, right and center if
compilers were really aggressive about this.
