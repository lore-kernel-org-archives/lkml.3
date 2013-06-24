Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab3FXSNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:13:37 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:60334 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008Ab3FXSNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:13:33 -0400
Message-ID: <51C88B76.90806@linux.vnet.ibm.com>
Date: Mon, 24 Jun 2013 23:39:58 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, peterz@infradead.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 22/45] percpu_counter: Use get/put_online_cpus_atomic()
 to prevent CPU offline
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com> <20130623134256.19094.99231.stgit@srivatsabhat.in.ibm.com> <20130624175535.GA1918@mtj.dyndns.org> <20130624180636.GB1918@mtj.dyndns.org>
In-Reply-To: <20130624180636.GB1918@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062418-6102-0000-0000-000003C00F75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 11:36 PM, Tejun Heo wrote:
> On Mon, Jun 24, 2013 at 10:55:35AM -0700, Tejun Heo wrote:
>>> @@ -105,6 +106,7 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
>>>  		ret += *pcount;
>>>  	}
>>>  	raw_spin_unlock(&fbc->lock);
>>> +	put_online_cpus_atomic();
>>
>> I don't think this is necessary.  CPU on/offlining is explicitly
>> handled via the hotplug callback which synchronizes through fbc->lock.
>> __percpu_counter_sum() racing with actual on/offlining doesn't affect
>> correctness and adding superflous get_online_cpus_atomic() around it
>> can be misleading.
> 
> Ah, okay, so you added a debug feature which triggers warning if
> online mask is accessed without synchronization.

Exactly!

>  Yeah, that makes
> sense and while the above is not strictly necessary, it probably is
> better to just add it rather than suppressing the warning in a
> different way.

Yeah, I was beginning to scratch my head as to how to suppress the
warning after I read your explanation as to why the calls to
get/put_online_cpus_atomic() would be superfluous in this case...

But as you said, simply invoking those functions is much simpler ;-)

>  Can you please at least add a comment explaining that?
> 

Sure, will do. Thanks a lot Tejun!
 
Regards,
Srivatsa S. Bhat

