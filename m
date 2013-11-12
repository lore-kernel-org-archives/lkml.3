Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3KLKUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:20:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57720 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946Ab3KLKUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:20:30 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <528200DE.1090706@jp.fujitsu.com>
Date: Tue, 12 Nov 2013 19:20:14 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/bsp-hotplug] x86, apic: Disable BSP if boot cpu is AP
References: <20130829092804.5476.95588.stgit@localhost6.localdomain6> <tip-1d79e607332d67d9132c176d99b5e7fabe1b6b7f@git.kernel.org> <52598770.6090309@zytor.com> <20131012174206.GD18437@gmail.com> <528135D8.3040205@zytor.com>
In-Reply-To: <528135D8.3040205@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/12 4:54), H. Peter Anvin wrote:
> On 10/12/2013 10:42 AM, Ingo Molnar wrote:
>>
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>
>>> On 10/09/2013 04:16 PM, tip-bot for HATAYAMA Daisuke wrote:
>>>> Commit-ID:  1d79e607332d67d9132c176d99b5e7fabe1b6b7f
>>>> Gitweb:     http://git.kernel.org/tip/1d79e607332d67d9132c176d99b5e7fabe1b6b7f
>>>> Author:     HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>>>> AuthorDate: Thu, 29 Aug 2013 18:28:04 +0900
>>>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>>>> CommitDate: Wed, 9 Oct 2013 15:41:11 -0700
>>>>
>>>> x86, apic: Disable BSP if boot cpu is AP
>>>
>>> This patch seems to trigger build failures in some configurations.
>>> Specifically:
>>>
>>> (.init.text+0x1307): undefined reference to `boot_cpu_is_bsp_init'
>>>
>>> Unfortunately I don't have the specific configuration which triggers the
>>> failure, as this was discovered by Fengguang's robot.
>>
>> I have triggered that too and have such a config, it's attached.
>
> Okay, thinking about this again, this patchset is in fact broken on:
>
> 1. Any configuration which has CONFIG_SMP=n and CONFIG_X86_UP_APIC=n.
>
> This is a built-time problem.
>
> 2. Any CPU which is old enough that MSR_IA32_APICBASE doesn't exist.
>
> This is a fatal runtime bug.
>
> 3. Any clustered solution which involves a third-party cluster
> controller such that MSR_IA32_APICBASE may not reflect the reality of
> the system.
>
> This is a less critical issue as "all" it ought to make happen is to
> disable some CPUs which didn't need it.
>
> Hatayama-san, you got this build bug report almost a month ago.  It
> looks like it is going to need a fair bit of cleanup, so I fear this is
> going to be dropped for v3.13.
>
> 	-hpa
>

Thanks for pointing out that. I think the first two issues has already been
fixed in v3 version. I've just posted v5 version a little time ago. BTW,
I changed the basic design at v4 where we specify the initial APIC ID of the
processor we want to disable in the kdump 2nd kernel from the the 1st kernel
through newly introduced disable_cpu_apicid kernel parameter; it might be
similar to the idea you described in the patch description of tip tree.

I don't know the third issue. Could you explain what kind of things can happen
on clustered system? Only IA32_APIC_BASE MSR is no longer trusted? Or are
there other things we can possibly no longer trust?

Also, could you explain what you suggest to deal with the issue in more detail?

-- 
Thanks.
HATAYAMA, Daisuke

