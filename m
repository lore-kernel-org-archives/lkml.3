Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaJ0SA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:00:57 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:44480 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaJ0SAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:00:55 -0400
X-Greylist: delayed 1347 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Oct 2014 14:00:55 EDT
Message-ID: <544E8846.9030003@hp.com>
Date: Mon, 27 Oct 2014 14:00:38 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>
Subject: Re: [PATCH v12 00/11] qspinlock: a 4-byte queue spinlock with PV
 support
References: <1413483040-58399-1-git-send-email-Waiman.Long@hp.com> <20141024085659.GW21513@worktop.programming.kicks-ass.net>
In-Reply-To: <20141024085659.GW21513@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 04:57 AM, Peter Zijlstra wrote:
> On Thu, Oct 16, 2014 at 02:10:29PM -0400, Waiman Long wrote:
>> v11->v12:
>>   - Based on PeterZ's version of the qspinlock patch
>>     (https://lkml.org/lkml/2014/6/15/63).
>>   - Incorporated many of the review comments from Konrad Wilk and
>>     Paolo Bonzini.
>>   - The pvqspinlock code is largely from my previous version with
>>     PeterZ's way of going from queue tail to head and his idea of
>>     using callee saved calls to KVM and XEN codes.
> Thanks for taking the time to refresh this.. I would prefer you use a
> little more of the PV techniques I outlined in my latest PV patch to
> further reduce the overhead of PV enabled kernels on real hardware.
>
> This is an important use case, because distro kernels will have to
> enable PV support while their majority of installations will be on
> physical hardware.
>
> Other than that I see no reason not to move this forward.

Thanks for reviewing the patch and agree to move forward. Currently, I 
am thinking of separating out a PV and non-PV versions of the lock 
slowpath functions as shown in my previous mail. That should also 
minimize the performance impact on bare metal even more than what can be 
done with the PV techniques used in your patch while not penalizing PV 
performance.

As for the unlock function, if the site patching function can handle all 
the possible call sites of spin_unlock() without disabling function 
inlining, I will be glad to use your way of handing unlock function. 
Otherwise, I will prefer my current approach as it is simpler and more 
easy to understand as well as similar to what has been done in the pv 
ticket spinlock code.

-Longman
