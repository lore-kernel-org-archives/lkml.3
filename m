Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133Ab3BHOs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:48:59 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:35508 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687Ab3BHOs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:48:58 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CAKohpom0yjSyU+OhK4vdi5R=+JsmAEw2nOsvupDOiWMYsdz3Pg@mail.gmail.com>
References: <CA+icZUX-hh+RjEOrKABBtecmb4C-5azSmdTx6D7SLuSpcQE+kQ@mail.gmail.com>
	<CAJd=RBDwdO+n3H4M=5W5q75q3yUVL7L2RonWnCE7sfsfW1K5ig@mail.gmail.com>
	<CA+icZUUaFb8zvdkY2JLz5h_7CBgaTzyyTphGid+GkigV+NfVKA@mail.gmail.com>
	<2612804.Hcyse1lRVO@vostro.rjw.lan>
	<CAKohpom0yjSyU+OhK4vdi5R=+JsmAEw2nOsvupDOiWMYsdz3Pg@mail.gmail.com>
Date: Fri, 8 Feb 2013 15:48:56 +0100
Message-ID: <CA+icZUUedcLAo1OkDSD7K_zgZoLvUAPNYOWAJxSPLp9J3hCKNw@mail.gmail.com>
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

On Fri, Feb 8, 2013 at 3:45 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 8 February 2013 18:51, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Friday, February 08, 2013 01:47:44 PM Sedat Dilek wrote:
>>> >> [    0.377473]  [<ffffffff8105a5ef>] warn_slowpath_common+0x7f/0xc0
>>> >> [    0.377479]  [<ffffffff81579130>] ? acpi_cpufreq_target+0x2c0/0x2c0
>>> >> [    0.377483]  [<ffffffff8105a64a>] warn_slowpath_null+0x1a/0x20
>>> >> [    0.377487]  [<ffffffff810bb7e6>] smp_call_function_single+0x146/0x190
>>> >> [    0.377492]  [<ffffffff81579130>] ? acpi_cpufreq_target+0x2c0/0x2c0
>>> >> [    0.377496]  [<ffffffff810bb881>] smp_call_function_any+0x51/0x100
>>> >> [    0.377500]  [<ffffffff815788c9>] get_cur_val+0x99/0x130
>>> >> [    0.377504]  [<ffffffff81579444>] ? acpi_cpufreq_cpu_init+0x2b4/0x6a0
>>> >> [    0.377508]  [<ffffffff81578db0>] get_cur_freq_on_cpu+0x60/0x80
>>> >> [    0.377512]  [<ffffffff815795a2>] acpi_cpufreq_cpu_init+0x412/0x6a0
>>> >> [    0.377517]  [<ffffffff81575bb9>] cpufreq_add_dev+0x2d9/0x4f0
>
>> This problem was introduced by some cpufreq changes that have been dropped from
>> linux-next for now (they are still present in the one you're testing, though).
>
> I know why you got this crash and a pull from following would
> certainly fix it :)
>
> http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-rafael

Nah, I pulled in latest pm-next where this commit is new...

commit 8d5666f3456f2fd4a4e5dced228475b829851e53
"ACPI: Unbind ACPI drv when probe failed"

...building with it.

Same to you, say concretely which commit is fixing what...

Pull-N-B-Happy was never my strategy... I want to understand what went
wrong and have stolen my time.

- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/rafael/linux-pm.git;a=commitdiff;h=8d5666f3456f2fd4a4e5dced228475b829851e53
