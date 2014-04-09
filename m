Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbaDIMDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:03:25 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45337 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbaDIMDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:03:22 -0400
Message-ID: <5345382B.3050400@linux.vnet.ibm.com>
Date: Wed, 09 Apr 2014 17:38:11 +0530
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
References: <1396445259-27670-1-git-send-email-Waiman.Long@hp.com> <5342425A.7040005@linux.vnet.ibm.com> <5342D475.7060503@hp.com> <5342E5B2.1070306@linux.vnet.ibm.com> <53444AEE.9050705@hp.com>
In-Reply-To: <53444AEE.9050705@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040912-5816-0000-0000-00000D622D0D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 12:45 AM, Waiman Long wrote:
> Yes, I am able to reproduce the hang problem with ebizzy. BTW, could you
> try to apply the attached patch file on top of the v8 patch series to
> see if it can fix the hang problem?

Ran the benchmarks with the fix and I am not seeing hang so far.
ebizzy improvements.

0.5x  2.7345
1x   -10.6593
1.5x  35.6962
2x    88.0461

dbench improvements
0.5x   3.2428
1x     1.1514
1.5x   5.5071
2x    23.8700
( I will have to restest on ebizzy 1x reression but overall performance
numbers look good).

>> Baseline was 3.14-rc8 without any of the qspin patch series.
>>
>
> Does the baseline have PV ticketlock or without any PV support?

baseline had PV ticketlock enabled.

