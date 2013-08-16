Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3HPQPy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:15:54 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751575Ab3HPQPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:15:50 -0400
Message-ID: <520E500B.5000408@nod.at>
Date: Fri, 16 Aug 2013 18:15:07 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] print_worker_info: Handle pointer with more care
References: <1376668606-32354-1-git-send-email-richard@nod.at> <20130816161229.GI2505@htj.dyndns.org>
In-Reply-To: <20130816161229.GI2505@htj.dyndns.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.08.2013 18:12, schrieb Tejun Heo:
> On Fri, Aug 16, 2013 at 05:56:46PM +0200, Richard Weinberger wrote:
>> The function has a nice comment:
>> /*
>>  * This function is called without any synchronization and @task
>>  * could be in any state.  Be careful with dereferences.
>>  */
>>
>> But a few lines later it blindly dereferences a few pointers.
>> E.g. It can happen that the worker function is already done,
>> then worker->current_pwq is NULL.
> ...
>>  	probe_kernel_read(&fn, &worker->current_func, sizeof(fn));
>>  	probe_kernel_read(&pwq, &worker->current_pwq, sizeof(pwq));
>> +	if (!pwq)
>> +		goto print;
>> +
>>  	probe_kernel_read(&wq, &pwq->wq, sizeof(wq));
>> +	if (!wq)
>> +		goto print;
>> +
> 
> But none of the above are dereferences.  &ptr->field is offset
> calculation, not a dereference.

On UML I hit the case that pwq is NULL.
Then we oops at &pwq->wq...

Thanks,
//richard

