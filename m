Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3LSP40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:56:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33014 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab3LSP4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:56:21 -0500
Message-ID: <52B316FF.50906@zytor.com>
Date: Thu, 19 Dec 2013 07:55:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Len Brown <lenb@kernel.org>
CC: x86@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power regression
References: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com> <20131219122257.GC11279@gmail.com>
In-Reply-To: <20131219122257.GC11279@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 04:22 AM, Ingo Molnar wrote:
>> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
>> index 92d1206..f80b700 100644
>> --- a/drivers/idle/intel_idle.c
>> +++ b/drivers/idle/intel_idle.c
>> @@ -377,6 +377,9 @@ static int intel_idle(struct cpuidle_device *dev,
>>  
>>  	if (!current_set_polling_and_test()) {
>>  
>> +		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
>> +			clflush((void *)&current_thread_info()->flags);
>> +
>>  		__monitor((void *)&current_thread_info()->flags, 0, 0);
> 
> I don't think either of these casts to '(void *)' is needed, both the 
> clflush() and __monitor() will take pointers.

__monitor() currently doesn't, which is idiotic.

	-hpa

