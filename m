Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaDRBvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 21:51:00 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:29352 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaDRBu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 21:50:58 -0400
Message-ID: <535084FE.2030902@hp.com>
Date: Thu, 17 Apr 2014 21:50:54 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 00/19] qspinlock: a 4-byte queue spinlock with PV support
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com> <20140417172246.GA9849@localhost.localdomain> <5350120C.40607@linux.vnet.ibm.com>
In-Reply-To: <5350120C.40607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 01:40 PM, Raghavendra K T wrote:
> On 04/17/2014 10:53 PM, Konrad Rzeszutek Wilk wrote:
>> On Thu, Apr 17, 2014 at 11:03:52AM -0400, Waiman Long wrote:
>>> v8->v9:
>>>    - Integrate PeterZ's version of the queue spinlock patch with some
>>>      modification:
>>>      http://lkml.kernel.org/r/20140310154236.038181843@infradead.org
>>>    - Break the more complex patches into smaller ones to ease review 
>>> effort.
>>>    - Fix a racing condition in the PV qspinlock code.
>>
>> I am not seeing anything mentioning that the overcommit scenario
>> for KVM and Xen had been fixed. Or was the 'racing condition' said
>> issue?
>
> Saw changes in patch 18 that fixes for kvm (19 for xen). 'll
> test the series and confirm.
>

The main fix is by replacing some barrier() with smp_mb(). The 
additional changes in kvm and xen are not the main one.

-Longman

