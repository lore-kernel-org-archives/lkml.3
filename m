Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3GGQ0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 12:26:33 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:53979 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3GGQ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 12:26:32 -0400
Message-ID: <51D99614.303@linux.vnet.ibm.com>
Date: Sun, 07 Jul 2013 21:53:48 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>, mingo@elte.hu,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, deepthi@linux.vnet.ibm.com,
        peterz@infradead.org, rusty@rustcorp.com.au, heiko.carstens@de.ibm.com,
        rostedt@goodmis.org, miltonm@bga.com, srivatsa.bhat@linux.vnet.ibm.com,
        tj@kernel.org, akpm@linux-foundation.org, svaidy@linux.vnet.ibm.com,
        shli@kernel.org, tglx@linutronix.de, lig.fnst@cn.fujitsu.com,
        anton@samba.org
Subject: Re: [PATCH 3/3] smp/ipi:Remove check around csd lock in handler for
 smp_call_function variants
References: <20130705162548.16888.18957.stgit@preeti.in.ibm.com> <20130705162720.16888.81958.stgit@preeti.in.ibm.com> <20130706054552.GA2929@udknight> <51D7D003.2030001@linux.vnet.ibm.com> <20130706142152.GA2227@udknight>
In-Reply-To: <20130706142152.GA2227@udknight>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070716-5490-0000-0000-000003C64376
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wang,

On 07/06/2013 07:51 PM, Wang YanQing wrote:
> On Sat, Jul 06, 2013 at 01:36:27PM +0530, Preeti U Murthy wrote:
>> Ideally it should be under a WARN_ON(). csd_unlock() has that WARN_ON().
>> Unlocking a parameter which is not locked should be seen as a bug, which
>> the above code is not doing. In fact it avoids it being reported as a bug.
> 
> Although I know what's your meaning, but just like the comment in code:
> 
> "
>  /*                                                                                               
>   * Unlocked CSDs are valid through generic_exec_single():                                        
>   */

I don't understand this comment. All callers of generic_exec_single()
take the csd lock. So where is the scenario of csds being unlocked in
generic_exec_single() before the call to
arch_send_call_function_single_ipi() is made?
  Rather what is the above comment trying to say?

> "
> 
> If the csd don't come from generic_exec_single, then
> Unlocked CSDs maybe are not valid. So we check CSD_FLAG_LOCK
> to avoid trigger the WARN_ON in csd_unlock.
> 
> Genric_exec_single's name imply it is a generic version,
> you know, maybe we will have "special" version.
> 
> Thanks.
> 

Regards
Preeti U Murthy

