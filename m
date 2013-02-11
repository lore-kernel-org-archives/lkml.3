Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab3BKM6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:58:18 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38082 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab3BKM6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:58:14 -0500
Message-ID: <5118EA6A.9040002@linux.vnet.ibm.com>
Date: Mon, 11 Feb 2013 18:26:10 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/45] percpu_rwlock: Introduce the global reader-writer
 lock backend
References: <20130122073315.13822.27093.stgit@srivatsabhat.in.ibm.com> <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <30708.1360586491@warthog.procyon.org.uk>
In-Reply-To: <30708.1360586491@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021112-2674-0000-0000-000007CA2964
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 06:11 PM, David Howells wrote:
> Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>> We can use global rwlocks as shown below safely, without fear of deadlocks:
>>
>> Readers:
>>
>>          CPU 0                                CPU 1
>>          ------                               ------
>>
>> 1.    spin_lock(&random_lock);             read_lock(&my_rwlock);
>>
>>
>> 2.    read_lock(&my_rwlock);               spin_lock(&random_lock);
> 
> The lock order on CPU 0 is unsafe if CPU2 can do:
> 
> 	write_lock(&my_rwlock);
> 	spin_lock(&random_lock);
> 
> and on CPU 1 if CPU2 can do:
> 
> 	spin_lock(&random_lock);
> 	write_lock(&my_rwlock);
> 

Right..

> I presume you were specifically excluding these situations?
>

Yes.. Those cases are simple to find out and fix (by changing the
lock ordering). My main problem was with CPU 0 and CPU 1 as shown above..
... and using a global rwlock helps ease that part out.

Regards,
Srivatsa S. Bhat

