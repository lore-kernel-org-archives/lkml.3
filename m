Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab3FWLwe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 07:52:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:61131 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab3FWLwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 07:52:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,922,1363158000"; 
   d="scan'208";a="334161609"
Message-ID: <51C6E16C.5030703@intel.com>
Date: Sun, 23 Jun 2013 19:52:12 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Peter Hurley <peter@hurleysoftware.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] rwsem: check the lock before cpmxchg in down_write_trylock
 and rwsem_do_wake
References: <cover.1371855277.git.tim.c.chen@linux.intel.com> <1371858695.22432.4.camel@schen9-DESK> <51C55082.5040500@hurleysoftware.com> <51C64C5D.5090400@intel.com> <20130623051018.GS6123@two.firstfloor.org>
In-Reply-To: <20130623051018.GS6123@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 01:10 PM, Andi Kleen wrote:
>>>> diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
>>>> > >> index bb1e2cd..052d973 100644
>>>> > >> --- a/include/asm-generic/rwsem.h
>>>> > >> +++ b/include/asm-generic/rwsem.h
>>>> > >> @@ -70,11 +70,11 @@ static inline void __down_write(struct
>>>> > >> rw_semaphore *sem)
>>>> > >>
>>>> > >>   static inline int __down_write_trylock(struct rw_semaphore *sem)
>>>> > >>   {
>>>> > >> -    long tmp;
>>>> > >> +    if (unlikely(&sem->count != RWSEM_UNLOCKED_VALUE))
>>> > >                      ^^^^^^^^^^^
>>> > > 
>>> > > This is probably not what you want.
>>> > > 
>> > 
>> > this function logical is quite simple. check the sem->count before
>> > cmpxchg is no harm this logical.
>> > 
>> > So could you like to tell us what should we want?
> You are comparing the address, not the value. Remove the &
> This was a nop too.

ops, So stupid I am! :(

-- 
Thanks
    Alex
