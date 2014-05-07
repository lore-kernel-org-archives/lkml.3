Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbaEGPAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:00:35 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:26796 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbaEGPAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:00:33 -0400
Message-ID: <536A4A7A.3050001@hp.com>
Date: Wed, 07 May 2014 11:00:10 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
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
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 00/19] qspinlock: a 4-byte queue spinlock with PV support
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com> <535D47D3.20202@linux.vnet.ibm.com>
In-Reply-To: <535D47D3.20202@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2014 02:09 PM, Raghavendra K T wrote:
>
> For kvm part feel free to add:
> Tested-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>
> V9 testing has shown no hangs.
> I was able to do some performance testing. here are the results:
>
> Overall we are seeing good improvement for pv-unfair version.
>
> System : 32 cpu sandybridge with HT on. (4 node machine with 32 GB each)
> Guest: 8GB with 16 vcpu/VM.
> Average was taken over 8-10 data points.
>
> Base = 3.15-rc2    with PRAVIRT_SPINLOCK = y
> A = 3.15-rc2 + qspinlock v9 patch with QUEUE_SPINLOCK = y 
> PRAVIRT_SPINLOCK = y PARAVIRT_UNFAIR_LOCKS = y (unfair lock)
> B =  3.15-rc2 + qspinlock v9 patch with QUEUE_SPINLOCK = y 
> PRAVIRT_SPINLOCK = n PARAVIRT_UNFAIR_LOCKS = n (queue spinlock without 
> paravirt)
> C = 3.15-rc2 + qspinlock v9 patch with  QUEUE_SPINLOCK = y 
> PRAVIRT_SPINLOCK = y  PARAVIRT_UNFAIR_LOCKS = n (queue spinlock with 
> paravirt)
>
>
> Ebizzy % improvements
> ========================
> overcommit A        B        C
> 0.5x    4.4265        2.0611        1.5824
> 1.0x    0.9015        -7.7828       4.5443
> 1.5x    46.1162       -2.9845       -3.5046
> 2.0x    99.8150       -2.7116       4.7461
>
> Dbench     %improvements
> overcommit A        B        C
> 0.5x    3.2617        3.5436        2.5676
> 1.0x    0.6302        2.2342        5.2201
> 1.5x    5.0027        4.8275        3.8375
> 2.0x    23.8242       4.5782        12.6067
>
> Absolute values of base results: (overcommit, value, stdev)
> Ebizzy ( records / sec with 120 sec run)
> 0.5x 20941.8750 (2%)
> 1.0x 17623.8750 (5%)
> 1.5x  5874.7778 (15%)
> 2.0x  3581.8750 (7%)
>
> Dbench (throughput in MB/sec)
> 0.5x 10009.6610 (5%)
> 1.0x  6583.0538 (1%)
> 1.5x  3991.9622 (4%)
> 2.0x  2527.0613 (2.5%)
>

Thank for the testing. I will include your Test-by tag in the next version.

-Longman
