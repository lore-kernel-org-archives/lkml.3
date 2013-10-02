Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3JBQm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:42:56 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58754 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434Ab3JBQmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:42:54 -0400
Message-ID: <524C4CC9.3080402@gmail.com>
Date: Thu, 03 Oct 2013 00:41:45 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Chen Gang <gang.chen@asianux.com>, Thomas Gleixner <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] about calling debug_hotplug_cpu() which enabled
 by 'allmodconfig' for a x86_64 dual core laptop.
References: <524B8E97.1030707@asianux.com> <1380727725.5429.13.camel@misato.fc.hp.com>
In-Reply-To: <1380727725.5429.13.camel@misato.fc.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 11:28 PM, Toshi Kani wrote:
> On Wed, 2013-10-02 at 03:10 +0000, Chen Gang wrote:
>> Hello Maintainers:
>>
>> Under my x86_64 dual core laptop, I build kernel next-20130927 with
>> 'allmodconfig', and install it, the machine can not start. Related
>> information is:
>>
>>   after call debug_hotplug_cpu(), output "cpu 0 is offline" .... and then "Failed to execute /init".
>>
>> After remove "_debug_hotplug_cpu(0, 0);", can pass the issue (but will
>> fail in another place). I guess, the reason is my laptop cpu is not
>> 'hotplug', but have to call debug_hotplug_cpu() with allmodconfig.
>>
>>
>> I will continue analyzing, welcome any additional suggestions or
>> completions.
> 
> allmodconfig sets CONFIG_DEBUG_HOTPLUG_CPU0 to y (which is defined as
> "def_bool n"), which puts CPU0 offline during boot for testing.  This
> debug feature is causing the problem on your laptop.  I am not familiar
> with allmodconfig, but it seems that it enables all the config options,
> preferably with 'm'.
> 

Hmm... excuse me, I don't know: for laptop, if cpu0 is offline, whether
it still can work or not. If any members know about it, please tell me,
thanks.

In my opinion, if enable DEBUG_HOTPLUG_CPU0, but "should not let cpu0
offline for laptop", we need let 'offline' operation fail.

And I am analyzing (just constructing environments: KVM, kgdb ...),
before let kernel start successfully, only according to my current
proofs, we can not say "let laptop cpu0 offline" must be an issue.

Thanks.

> Thanks,
> -Toshi
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Thanks.
-- 
Chen Gang
