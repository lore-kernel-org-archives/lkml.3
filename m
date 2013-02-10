Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761066Ab3BJTcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 14:32:12 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53505 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760521Ab3BJTcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 14:32:09 -0500
Message-ID: <5117F53A.20307@linux.vnet.ibm.com>
Date: Mon, 11 Feb 2013 01:00:02 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 05/45] percpu_rwlock: Make percpu-rwlocks IRQ-safe,
 optimally
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <20130122073400.13822.52336.stgit@srivatsabhat.in.ibm.com> <20130210184209.GA3041@redhat.com>
In-Reply-To: <20130210184209.GA3041@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021019-5140-0000-0000-000002BC5F26
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 12:12 AM, Oleg Nesterov wrote:
> only one cosmetic nit...
> 
> On 01/22, Srivatsa S. Bhat wrote:
>>
>> +#define READER_PRESENT		(1UL << 16)
>> +#define READER_REFCNT_MASK	(READER_PRESENT - 1)
>> +
>>  #define reader_uses_percpu_refcnt(pcpu_rwlock, cpu)			\
>>  		(ACCESS_ONCE(per_cpu(*((pcpu_rwlock)->reader_refcnt), cpu)))
>>
>>  #define reader_nested_percpu(pcpu_rwlock)				\
>> -			(__this_cpu_read(*((pcpu_rwlock)->reader_refcnt)) > 1)
>> +	(__this_cpu_read(*((pcpu_rwlock)->reader_refcnt)) & READER_REFCNT_MASK)
>>
>>  #define writer_active(pcpu_rwlock)					\
>>  			(__this_cpu_read(*((pcpu_rwlock)->writer_signal)))
> 
> I think this all can go to lib/percpu-rwlock.c. Nobody needs to know
> these implementation details.
> 

Ok, will move them.
 
Regards,
Srivatsa S. Bhat

