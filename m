Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946710Ab3BHQvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 11:51:12 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:55161 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098Ab3BHQvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 11:51:07 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXHD9kQ0JUZ-31Oc3OWaKr7zpWfBG7L_n5kG7QQW+aUDg@mail.gmail.com>
References: <CA+icZUX-hh+RjEOrKABBtecmb4C-5azSmdTx6D7SLuSpcQE+kQ@mail.gmail.com>
	<CAJd=RBDwdO+n3H4M=5W5q75q3yUVL7L2RonWnCE7sfsfW1K5ig@mail.gmail.com>
	<CA+icZUUaFb8zvdkY2JLz5h_7CBgaTzyyTphGid+GkigV+NfVKA@mail.gmail.com>
	<2612804.Hcyse1lRVO@vostro.rjw.lan>
	<CAKohpom0yjSyU+OhK4vdi5R=+JsmAEw2nOsvupDOiWMYsdz3Pg@mail.gmail.com>
	<CA+icZUUedcLAo1OkDSD7K_zgZoLvUAPNYOWAJxSPLp9J3hCKNw@mail.gmail.com>
	<CAOh2x=nn24DC-jpD_UsZ2z6=5d9GmZqwowKF8X0zQQX=vZmbqQ@mail.gmail.com>
	<CA+icZUV=813qjoTMUQzHvUD2AChgKO60ffRtrJ2OG0uSqZf3Mw@mail.gmail.com>
	<CA+icZUXHD9kQ0JUZ-31Oc3OWaKr7zpWfBG7L_n5kG7QQW+aUDg@mail.gmail.com>
Date: Fri, 8 Feb 2013 17:51:05 +0100
Message-ID: <CA+icZUWo4um9s-FhF5HoN5-WbkbNDTjnGkMMRHc60GWohcrPvA@mail.gmail.com>
Subject: Re: [linux-pm] linux-next: Tree for Feb 8 [ smp|cpufreq: WARNING: at
 kernel/smp.c:245 smp_call_function_single ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>, linux-next@vger.kernel.org,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 5:28 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Feb 8, 2013 at 4:21 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Fri, Feb 8, 2013 at 3:56 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> On Fri, Feb 8, 2013 at 8:18 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>> Nah, I pulled in latest pm-next where this commit is new...
>>>>
>>>> commit 8d5666f3456f2fd4a4e5dced228475b829851e53
>>>> "ACPI: Unbind ACPI drv when probe failed"
>>>>
>>>> ...building with it.
>>>>
>>>> Same to you, say concretely which commit is fixing what...
>>>>
>>>> Pull-N-B-Happy was never my strategy... I want to understand what went
>>>> wrong and have stolen my time.
>>>
>>> I don't have any pointers to broken tree and so can't point you to the culprit,
>>> but it was this patch:
>>>
>>> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=commit;h=e034e731f4d9d18ad0401f033f485a3096796c58
>>>
>>> minus
>>>
>>> the patch i sent you as attachment.
>>>
>>> There were some locking introduced around init/exit of cpufreq_driver, which
>>> caused some drivers to break. Its fixed now in the above commit.
>>
>> Hmm, this "high-patch-maths" is not user-friendly!
>>
>> I will pull-in your tree into Linux-Next (next-20130208) and see if it
>> applies cleanly.
>>
>> - Sedat -
>
> No, it did NOT apply cleanly and I merged your tree like this.
> To me it does not look like your changes from the patch you sent me
> are included?
>
> - Sedat -

Looks like I did it correct - no WARNINGs.

# diff -uprN /boot/config-3.8.0-rc6-next20130208-1-iniza-small
/boot/config-3.8.0-rc6-next20130208-6-iniza-small
--- /boot/config-3.8.0-rc6-next20130208-1-iniza-small   2013-02-08
09:34:59.000000000 +0100
+++ /boot/config-3.8.0-rc6-next20130208-6-iniza-small   2013-02-08
17:36:02.000000000 +0100
@@ -601,6 +601,7 @@ CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
 #
 # x86 CPU frequency scaling drivers
 #
+CONFIG_X86_INTEL_PSTATE=y
 CONFIG_X86_PCC_CPUFREQ=y
 CONFIG_X86_ACPI_CPUFREQ=y
 CONFIG_X86_ACPI_CPUFREQ_CPB=y

# dmesg | grep -i pstate
[    0.387256] Intel pstate controlling: cpu 0
[    0.387273] Intel pstate controlling: cpu 1
[    0.387286] Intel pstate controlling: cpu 2
[    0.387303] Intel pstate controlling: cpu 3
[  151.315937] Intel pstate controlling: cpu 1
[  151.329400] Intel pstate controlling: cpu 2
[  151.342778] Intel pstate controlling: cpu 3

So, suspend-resume is good here.

- Sedat -
