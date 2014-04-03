Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801AbaDCCKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 22:10:52 -0400
Received: from g6t1524.atlanta.hp.com ([15.193.200.67]:9839 "EHLO
	g6t1524.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbaDCCKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 22:10:50 -0400
Message-ID: <533CC309.3020607@hp.com>
Date: Wed, 02 Apr 2014 22:10:17 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Marcos Matsunaga <Marcos.Matsunaga@oracle.com>,
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
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH v8 00/10] qspinlock: a 4-byte queue spinlock with PV support
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com> <20140402143201.GF12188@phenom.dumpdata.com> <533C7485.3030203@hp.com>
In-Reply-To: <533C7485.3030203@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 04:35 PM, Waiman Long wrote:
> On 04/02/2014 10:32 AM, Konrad Rzeszutek Wilk wrote:
>> On Wed, Apr 02, 2014 at 09:27:29AM -0400, Waiman Long wrote:
>>> N.B. Sorry for the duplicate. This patch series were resent as the
>>>       original one was rejected by the vger.kernel.org list server
>>>       due to long header. There is no change in content.
>>>
>>> v7->v8:
>>>    - Remove one unneeded atomic operation from the slowpath, thus
>>>      improving performance.
>>>    - Simplify some of the codes and add more comments.
>>>    - Test for X86_FEATURE_HYPERVISOR CPU feature bit to enable/disable
>>>      unfair lock.
>>>    - Reduce unfair lock slowpath lock stealing frequency depending
>>>      on its distance from the queue head.
>>>    - Add performance data for IvyBridge-EX CPU.
>> FYI, your v7 patch with 32 VCPUs (on a 32 cpu socket machine) on an
>> HVM guest under Xen after a while stops working. The workload
>> is doing 'make -j32' on the Linux kernel.
>>
>> Completely unresponsive. Thoughts?
>>
>
> Thank for reporting that. I haven't done that much testing on Xen. My 
> focus was in KVM. I will perform more test on Xen to see if I can 
> reproduce the problem.
>

BTW, does the halting and sending IPI mechanism work in HVM? I saw that 
in RHEL7, PV spinlock was explicitly disabled when in HVM mode. However, 
this piece of code isn't in upstream code. So I wonder if there is 
problem with that.

-Longman
