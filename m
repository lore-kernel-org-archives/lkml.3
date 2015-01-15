Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbbAOVBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:01:07 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:42516 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbbAOVBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:01:04 -0500
Message-ID: <54B82A8B.7000809@de.ibm.com>
Date: Thu, 15 Jan 2015 22:00:59 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/8] x86/spinlock: Leftover conversion ACCESS_ONCE->READ_ONCE
References: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com> <1421312314-72330-5-git-send-email-borntraeger@de.ibm.com> <20150115193839.GA28727@redhat.com> <54B81A37.80109@de.ibm.com> <20150115200119.GA29684@redhat.com>
In-Reply-To: <20150115200119.GA29684@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011521-0041-0000-0000-000002E3FF8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.01.2015 um 21:01 schrieb Oleg Nesterov:
> On 01/15, Christian Borntraeger wrote:
>>
>> Am 15.01.2015 um 20:38 schrieb Oleg Nesterov:
>>> On 01/15, Christian Borntraeger wrote:
>>>>
>>>> --- a/arch/x86/include/asm/spinlock.h
>>>> +++ b/arch/x86/include/asm/spinlock.h
>>>> @@ -186,7 +186,7 @@ static inline void arch_spin_unlock_wait(arch_spinlock_t *lock)
>>>>  	__ticket_t head = ACCESS_ONCE(lock->tickets.head);
>>>>
>>>>  	for (;;) {
>>>> -		struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
>>>> +		struct __raw_tickets tmp = READ_ONCE(lock->tickets);
>>>
>>> Agreed, but what about another ACCESS_ONCE() above?
>>>
>>> Oleg.
>>
>> tickets.head is a scalar type, so ACCESS_ONCE does work fine with gcc 4.6/4.7.
>> My goal was to convert all accesses on non-scalar types
> 
> I understand, but READ_ONCE(lock->tickets.head) looks better anyway and
> arch_spin_lock() already use READ_ONCE() for this.
> 
> So why we should keep the last ACCESS_ONCE() in spinlock.h ? Just to make
> another cosmetic cleanup which touches the same function later?

OK, I will change that one as well.


