Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaIDUnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 16:43:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38925 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaIDUnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 16:43:09 -0400
Message-ID: <5408CEDA.7090209@canonical.com>
Date: Thu, 04 Sep 2014 15:43:06 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com> <54088CB5.6050406@canonical.com> <54089DDE.6010004@redhat.com> <5408AC76.6030404@canonical.com> <5408BA6D.1070602@redhat.com> <5408C0B4.5040207@redhat.com> <5408CD83.50904@canonical.com> <5408CE32.8010204@redhat.com>
In-Reply-To: <5408CE32.8010204@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/04/2014 03:40 PM, Paolo Bonzini wrote:
> Il 04/09/2014 22:37, Chris J Arges ha scritto:
>>>> -	boot_ns = ktime_to_ns(ktime_add(tk->tkr.base_mono, tk->offs_boot));
>>>> +	boot_ns = ktime_to_ns(ktime_sub(tk->offs_real, tk->offs_boot));
>>>>  
>>>>  	write_seqcount_begin(&vdata->seq);
>>>>
>>>> If it doesn't work, then commit 02cba1598a2a3b689e79ad6dad2532521f638271
>>>> is also broken.
>>>>
>>>> Paolo
>>>>
>> Paolo,
>> That modification do your additional patch didn't work. However I was
>> able to modify the code as follows to get this test case working. The
>> only additional modification was:
>> +	vdata->nsec_base		= tk->xtime_sec * (u64)NSEC_PER_SEC
>> +					- boot_ns;
> 
> Right, it should have been
> 
> 	boot_ns = ktime_to_ns(ktime_sub(tk->offs_boot, tk->offs_real));
> 
> I'll post the patch shortly.
> 
> Thanks!
> 
> Paolo
> 

Paolo,

Great, tested that modification really quick and it also works for me!
All test cases are now passing on my machine; thanks for all the
debugging and help.

--chris
