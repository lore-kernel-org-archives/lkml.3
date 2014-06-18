Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966270AbaFRMEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:04:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965999AbaFRMER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:04:17 -0400
Message-ID: <53A18000.8080909@redhat.com>
Date: Wed, 18 Jun 2014 14:03:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: tglx@linutronix.de, mingo@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/11] qspinlock: Paravirt support
References: <20140615124657.264658593@chello.nl> <20140615130154.213923590@chello.nl> <539F6AD5.4070301@hp.com>
In-Reply-To: <539F6AD5.4070301@hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/06/2014 00:08, Waiman Long ha scritto:
>> +void __pv_queue_unlock(struct qspinlock *lock)
>> +{
>> +	int val = atomic_read(&lock->val);
>> +
>> +	native_queue_unlock(lock);
>> +
>> +	if (val & _Q_LOCKED_SLOW)
>> +		___pv_kick_head(lock);
>> +}
>> +
>
> Again a race can happen here between the reading and writing of the lock
> value. I can't think of a good way to do that without using cmpxchg.

Could you just use xchg on the locked byte?

Paolo
