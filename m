Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab3BSLAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 06:00:55 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:56074 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab3BSLAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 06:00:52 -0500
Message-ID: <51235AD6.9040407@linux.vnet.ibm.com>
Date: Tue, 19 Feb 2013 16:28:30 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>
CC: Michel Lespinasse <walken@google.com>, linux-doc@vger.kernel.org,
        peterz@infradead.org, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        mingo@kernel.org, linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        xiaoguangrong@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, rusty@rustcorp.com.au, rostedt@goodmis.org,
        rjw@sisk.pl, namhyung@kernel.org, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        oleg@redhat.com, vincent.guittot@linaro.org, sbw@mit.edu,
        tj@kernel.org, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v6 08/46] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com> <20130218123920.26245.56709.stgit@srivatsabhat.in.ibm.com> <CANN689HhVxDv+3Bn9UAxOMzj0egTvVp_c7oAmQ2nnQ8Xjn_aMA@mail.gmail.com> <51225A36.40600@linux.vnet.ibm.com> <CANN689FJPLfz06MFRJ9T+BuToejAzjYP_yrw_H4iGi1Kb3p2-g@mail.gmail.com> <51227810.6090009@linux.vnet.ibm.com> <CANN689E-98zK69pGeojbm30n3sswQYVBvhk3i3OzqvbeqSrSrg@mail.gmail.com> <51234C23.2030909@linux.vnet.ibm.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7154@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7154@saturn3.aculab.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021910-5816-0000-0000-000006BD3FB6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 04:12 PM, David Laight wrote:
>> I wouldn't go that far... ;-) Unfairness is not a show-stopper right?
>> IMHO, the warning/documentation should suffice for anybody wanting to
>> try out this locking scheme for other use-cases.
> 
> I presume that by 'fairness' you mean 'write preference'?
> 

Yep.

> I'd not sure how difficult it would be, but maybe have two functions
> for acquiring the lock for read, one blocks if there is a writer
> waiting, the other doesn't.
> 
> That way you can change the individual call sites separately.
>

Right, we could probably use that method to change the call sites in
multiple stages, in the future.
 
> The other place I can imagine a per-cpu rwlock being used
> is to allow a driver to disable 'sleep' or software controlled
> hardware removal while it performs a sequence of operations.
> 

BTW, per-cpu rwlocks use spinlocks underneath, so they can be used only
in atomic contexts (you can't sleep holding this lock). So that would
probably make it less attractive or useless to "heavy-weight" usecases
like the latter one you mentioned. They probably need to use per-cpu
rw-semaphore or some such, which allows sleeping. I'm not very certain
of the exact usecases you are talking about, but I just wanted to
point out that percpu-rwlocks might not be applicable to many scenarios.
..(which might be a good thing, considering its unfair property today).

Regards,
Srivatsa S. Bhat

