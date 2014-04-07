Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbaDGRq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:46:56 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:52223 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbaDGRqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:46:49 -0400
Message-ID: <5342E5B2.1070306@linux.vnet.ibm.com>
Date: Mon, 07 Apr 2014 23:21:46 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v8 00/10] qspinlock: a 4-byte queue spinlock with PV support
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com> <5342425A.7040005@linux.vnet.ibm.com> <5342D475.7060503@hp.com>
In-Reply-To: <5342D475.7060503@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040717-5490-0000-0000-00000553C557
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 10:08 PM, Waiman Long wrote:
> On 04/07/2014 02:14 AM, Raghavendra K T wrote:
[...]
>> But I am seeing hang in overcommit cases. Gdb showed that many vcpus
>> are halted and there was no progress. Suspecting the problem /race with
>> halting, I removed the halt() part of kvm_hibernate().  I am yet to
>> take a closer look at the code on halt() related changes.
>
> It seems like there may still be race conditions where the current code
> is not handling correctly. I will look into that to see where the
> problem is. BTW, what test do you use to produce the hang condition?

Running ebizzy on 2 of the vms simultaneously (for sometime in repeated 
loop) could reproduce it.

>> Patch series with that change gave around 20% improvement for dbench
>> 2x and 30% improvement for ebizzy 2x cases. (1x has no significant
>> loss/gain).
>>

While at it, Just  a correction it was 30% for  ebizzy1.5x  and around
80% for ebizzy 2x.

> What is the baseline for the performance improvement? Is it without the
> unfair lock and PV qspinlock?

Baseline was 3.14-rc8 without any of the qspin patch series.

