Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbaGALO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 07:14:29 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:52327 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894AbaGALO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 07:14:26 -0400
Message-ID: <53B2974A.6010809@linux.vnet.ibm.com>
Date: Tue, 01 Jul 2014 16:41:06 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        konrad.wilk@oracle.com, pbonzini@redhat.com, gleb@redhat.com,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        waiman.long@hp.com, riel@redhat.com, davej@redhat.com, oleg@redhat.com,
        x86@kernel.org, jeremy@goop.org, paul.gortmaker@windriver.com,
        ak@linux.intel.com, jasowang@redhat.com, fernando_b1@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, mtosatti@redhat.com,
        chegu_vinod@hp.com
Subject: Re: [RFC PATCH v2] Implement Batched (group) ticket lock
References: <1403947024-3193-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140701080537.GH6758@twins.programming.kicks-ass.net> <53B282E9.6060806@linux.vnet.ibm.com> <20140701095521.GO6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140701095521.GO6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070111-5140-0000-0000-00000568E004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> For baremetal we continue to have 'fully fair ticketlock' with this patch
>> series.
>>
>
> But but but, we're looking at removing ticket locks. So why do we want
> to invest in them now?
>

I have nothing against qspinlock. I am happy to test it/add any bit to 
it if I could.

With this patch we get excellent performance for guest with the
unmodified kernel without affecting host.

My test on guest with batch_size =16,32 showed even better performance
               bs=16      bs=32
  ebizzy_0.5x   0.14       0.90
  ebizzy_1.0x   3.57       7.52
  ebizzy_1.5x  58.97      67.65
  ebizzy_2.0x 121.55     136.45




