Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaEHRyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:54:35 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:51305 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaEHRyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:54:33 -0400
Message-ID: <536BC4BF.9030603@hp.com>
Date: Thu, 08 May 2014 13:54:07 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 18/19] pvqspinlock, x86: Enable PV qspinlock PV for
 KVM
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com> <1399474907-22206-19-git-send-email-Waiman.Long@hp.com> <20140507190706.GA16333@phenom.dumpdata.com>
In-Reply-To: <20140507190706.GA16333@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 03:07 PM, Konrad Rzeszutek Wilk wrote:
>> Raghavendra KT had done some performance testing on this patch with
>> the following results:
>>
>> Overall we are seeing good improvement for pv-unfair version.
>>
>> System: 32 cpu sandybridge with HT on (4 node with 32 GB each)
>> Guest : 8GB with 16 vcpu/VM.
>> Average was taken over 8-10 data points.
>>
>> Base = 3.15-rc2  with PRAVIRT_SPINLOCK = y
>>
>> A = 3.15-rc2 + qspinlock v9 patch with QUEUE_SPINLOCK = y
>> PRAVIRT_SPINLOCK = y PARAVIRT_UNFAIR_LOCKS = y (unfair lock)
>>
>> B =  3.15-rc2 + qspinlock v9 patch with QUEUE_SPINLOCK = y
>> PRAVIRT_SPINLOCK = n PARAVIRT_UNFAIR_LOCKS = n
>> (queue spinlock without paravirt)
>>
>> C = 3.15-rc2 + qspinlock v9 patch with  QUEUE_SPINLOCK = y
>> PRAVIRT_SPINLOCK = y  PARAVIRT_UNFAIR_LOCKS = n
>> (queue spinlock with paravirt)
> Could you do s/PRAVIRT/PARAVIRT/ please?
>

Sorry for the typo, I didn't check the text carefully enough when I 
cut-and-paste it from Raghavendra's email.

>> Ebizzy %improvements
>> ====================
>> overcommit  A            B            C
>> 0.5x     4.4265        2.0611       1.5824
>> 1.0x     0.9015       -7.7828       4.5443
>> 1.5x    46.1162       -2.9845      -3.5046
>> 2.0x    99.8150       -2.7116       4.7461
> Considering B sucks

Yes, I don't expect the plain qspinlock code will perform well in a 
guest without either unfair or pvspinlock support.

-Longman
