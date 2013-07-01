Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3GAQKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:10:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48931 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab3GAQKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:10:47 -0400
Date: Mon, 1 Jul 2013 09:03:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/7] v2 Provide infrastructure for
 full-system idle
Message-ID: <20130701160314.GM3773@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130628200949.GA17458@linux.vnet.ibm.com>
 <87a9m65mv6.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a9m65mv6.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070116-7606-0000-0000-00000CF13E34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 08:19:25AM -0700, Andi Kleen wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> >
> > The individual patches are as follows:
> >
> > 1.	Add a CONFIG_NO_HZ_FULL_SYSIDLE Kconfig parameter to enable
> > 	this feature.  Kernels built with CONFIG_NO_HZ_FULL_SYSIDLE=n
> > 	act exactly as they do today.
> 
> Is this extra CONFIG option really needed? RCU already has a bewildering
> variety of CONFIG options, and no idle CONFIG is also pretty complicated. 
> At some point noone will know how to configure kernels anymore if 
> these non trivial, complicated trade off CONFIGs keep spreading.
> 
> The facility sounds like a good thing in general. Just enable
> it implicitely with NO_HZ_SYSIDLE ? 

I am guessing that you want CONFIG_NO_HZ_FULL to implicitly enable
the sysidle code so that CONFIG_NO_HZ_FULL_SYSIDLE can be eliminated.
I will be happy to take that step, but only after I gain full confidence
in the correctness and performance of the sysidle code.

> If you want a switch for testing I would advise a sysctl or sysfs knob

This would work well for the correctness part, but not for the performance
part.

							Thanx, Paul

