Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3KKTyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 14:54:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48054 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754081Ab3KKTyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 14:54:18 -0500
Message-ID: <528135D8.3040205@zytor.com>
Date: Mon, 11 Nov 2013 11:54:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        d.hatayama@jp.fujitsu.com, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/bsp-hotplug] x86, apic: Disable BSP if boot cpu is AP
References: <20130829092804.5476.95588.stgit@localhost6.localdomain6> <tip-1d79e607332d67d9132c176d99b5e7fabe1b6b7f@git.kernel.org> <52598770.6090309@zytor.com> <20131012174206.GD18437@gmail.com>
In-Reply-To: <20131012174206.GD18437@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2013 10:42 AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> On 10/09/2013 04:16 PM, tip-bot for HATAYAMA Daisuke wrote:
>>> Commit-ID:  1d79e607332d67d9132c176d99b5e7fabe1b6b7f
>>> Gitweb:     http://git.kernel.org/tip/1d79e607332d67d9132c176d99b5e7fabe1b6b7f
>>> Author:     HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
>>> AuthorDate: Thu, 29 Aug 2013 18:28:04 +0900
>>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>>> CommitDate: Wed, 9 Oct 2013 15:41:11 -0700
>>>
>>> x86, apic: Disable BSP if boot cpu is AP
>>
>> This patch seems to trigger build failures in some configurations.
>> Specifically:
>>
>> (.init.text+0x1307): undefined reference to `boot_cpu_is_bsp_init'
>>
>> Unfortunately I don't have the specific configuration which triggers the 
>> failure, as this was discovered by Fengguang's robot.
> 
> I have triggered that too and have such a config, it's attached.

Okay, thinking about this again, this patchset is in fact broken on:

1. Any configuration which has CONFIG_SMP=n and CONFIG_X86_UP_APIC=n.

This is a built-time problem.

2. Any CPU which is old enough that MSR_IA32_APICBASE doesn't exist.

This is a fatal runtime bug.

3. Any clustered solution which involves a third-party cluster
controller such that MSR_IA32_APICBASE may not reflect the reality of
the system.

This is a less critical issue as "all" it ought to make happen is to
disable some CPUs which didn't need it.

Hatayama-san, you got this build bug report almost a month ago.  It
looks like it is going to need a fair bit of cleanup, so I fear this is
going to be dropped for v3.13.

	-hpa

