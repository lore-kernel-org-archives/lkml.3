Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab3GFOXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 10:23:34 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:64927 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3GFOXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 10:23:33 -0400
Date: Sat, 6 Jul 2013 22:21:52 +0800
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
Message-ID: <20130706142152.GA2227@udknight>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D7D003.2030001@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 01:36:27PM +0530, Preeti U Murthy wrote:
> Ideally it should be under a WARN_ON(). csd_unlock() has that WARN_ON().
> Unlocking a parameter which is not locked should be seen as a bug, which
> the above code is not doing. In fact it avoids it being reported as a bug.

Although I know what's your meaning, but just like the comment in code:

"
 /*                                                                                               
  * Unlocked CSDs are valid through generic_exec_single():                                        
  */
"

If the csd don't come from generic_exec_single, then
Unlocked CSDs maybe are not valid. So we check CSD_FLAG_LOCK
to avoid trigger the WARN_ON in csd_unlock.

Genric_exec_single's name imply it is a generic version,
you know, maybe we will have "special" version.

Thanks.
