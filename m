Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaFRPu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:50:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbaFRPuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:50:55 -0400
Message-ID: <53A1B520.6090902@redhat.com>
Date: Wed, 18 Jun 2014 17:49:52 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
        mingo@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 04/11] qspinlock: Extract out the exchange of tail code
 word
References: <20140615124657.264658593@chello.nl> <20140615130153.376621956@chello.nl> <20140617205525.GB29634@laptop.dumpdata.com> <53A17A09.6010007@redhat.com> <20140618135057.GB4729@laptop.dumpdata.com> <53A1B43C.8000009@hp.com>
In-Reply-To: <53A1B43C.8000009@hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/06/2014 17:46, Waiman Long ha scritto:
>>
>>
>> The #1 patch is nice by itself - as it lays out the foundation of the
>> MCS-similar code - and if Ingo decides he does not want this pending
>> byte-lock bit business - it can be easily reverted or dropped.
>
> The pending bit code is needed for performance parity with ticket
> spinlock for light load. My own measurement indicates that the queuing
> overhead will cause the queue spinlock to be slower than ticket spinlock
> with 2-4 contending tasks. The pending bit solves the performance
> problem with 2 contending tasks, leave only the 3-4 tasks cases being a
> bit slower than the ticket spinlock which should be more than
> compensated by its superior performance with heavy contention and
> slightly better performance with no contention.

Note that this patch is not related to the pending bit, only to the 
trylock bit which is already in patch 1.  It serializes two 
previously-parallel checks for transitions.  This is why I thought it 
could already belong in patch 1.

Paolo
