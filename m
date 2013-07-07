Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab3GGR0u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 13:26:50 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41974 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3GGR0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 13:26:48 -0400
Date: Mon, 8 Jul 2013 01:25:41 +0800
From: Wang YanQing <udknight@gmail.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: mingo@elte.hu, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, deepthi@linux.vnet.ibm.com,
        peterz@infradead.org, rusty@rustcorp.com.au, heiko.carstens@de.ibm.com,
        rostedt@goodmis.org, miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        tj@kernel.org, akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
        shli@kernel.org, tglx@linutronix.de, lig.fnst@cn.fujitsu.com,
        anton@samba.org
Subject: Re: [PATCH 3/3] smp/ipi:Remove check around csd lock in handler for
 smp_call_function variants
Message-ID: <20130707172541.GA3218@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Preeti U Murthy <preeti@linux.vnet.ibm.com>, mingo@elte.hu,
	paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	a.p.zijlstra@chello.nl, deepthi@linux.vnet.ibm.com,
	peterz@infradead.org, rusty@rustcorp.com.au,
	heiko.carstens@de.ibm.com, rostedt@goodmis.org, miltonm@bga.com,
	srivatsa.bhat@linux.vnet.ibm.com, tj@kernel.org,
	akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
	shli@kernel.org, tglx@linutronix.de, lig.fnst@cn.fujitsu.com,
	anton@samba.org
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com>
 <20130705162720.16888.81958.stgit@preeti.in.ibm.com>
 <20130706054552.GA2929@udknight>
 <51D7D003.2030001@linux.vnet.ibm.com>
 <20130706142152.GA2227@udknight>
 <51D99614.303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D99614.303@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 07, 2013 at 09:53:48PM +0530, Preeti U Murthy wrote:
> > "
> >  /*                                                                                               
> >   * Unlocked CSDs are valid through generic_exec_single():                                        
> >   */
> 
> I don't understand this comment. All callers of generic_exec_single()
> take the csd lock. So where is the scenario of csds being unlocked in
> generic_exec_single() before the call to
> arch_send_call_function_single_ipi() is made?
>   Rather what is the above comment trying to say?

I have given the answer to this question in last reply.

I don't know whether it is right to make a assumption through
this way that what you do currently:

Find all the current api users, and drop all the robust codes,
despite the unpredictable future users.

Ok, I know the balance between "robust" vs "performance",
robust check codes will bring performance penalty in fastest
code path, but the "penalty" is neglectable sometimes for
modern CPU.

I decide to respect the MAINTAINER's decision to accept this 
change or not.

Thanks.



