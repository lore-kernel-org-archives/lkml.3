Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965727AbaCSQJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:09:45 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:48832 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965684AbaCSQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:09:42 -0400
Date: Wed, 19 Mar 2014 21:39:33 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: davidlohr@hp.com, torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org,
        paulus@samba.org
Subject: Re: Tasks stuck in futex code (in 3.14-rc6)
Message-ID: <20140319160933.GA30295@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140319152619.GB10406@linux.vnet.ibm.com>
 <20140319154705.GB8557@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140319154705.GB8557@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031916-5490-0000-0000-00000533FE0C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > Infact I can reproduce this if the java_constraint is either node, socket, system.
> > However I am not able to reproduce if java_constraint is set to core.
> 
> What's any of that mean?
> 

Using the constraint, one can specify how many jvm instances should
participate in the specjbb run.

For example on a 4 node box, I can say 2 jvms per constraint with
constraint set to node and specjbb will run with 8 instances of java.

I was running with 1 jvm per constraint. But when I set the constraint
to node/System, I keep seeing this problem. However if I set the
constraint to core (which means running more instances of java), the
problem is not seen. I kind of guess, the lesser the number of java
instances the easier it is to reproduce. 

-- 
Thanks and Regards
Srikar Dronamraju

