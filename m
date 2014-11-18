Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbaKRPBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:01:33 -0500
Received: from mail-yk0-f174.google.com ([209.85.160.174]:51992 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbaKRPB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:01:29 -0500
MIME-Version: 1.0
In-Reply-To: <20141117230232.GC25157@pd.tnic>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
	<1416251225-17721-14-git-send-email-eranian@google.com>
	<20141117230232.GC25157@pd.tnic>
Date: Tue, 18 Nov 2014 17:01:28 +0200
Message-ID: <CAHzUATiZPYNt5nQ82TmCGH9mz0-Y-T6UFdo+0xHpYNcMFBnfZw@mail.gmail.com>
Subject: Re: [PATCH v3 13/13] perf/x86: add syfs entry to disable HT bug workaround
From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>, x86-ml <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, kan.liang@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 1:02 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Nov 17, 2014 at 08:07:05PM +0100, Stephane Eranian wrote:
>> From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
>>
>> This patch adds a sysfs entry:
>>
>>       /sys/devices/cpu/ht_bug_workaround
>>
>> to activate/deactivate the PMU HT bug workaround.
>>
>> To activate (activated by default):
>>  # echo 1 > /sys/devices/cpu/ht_bug_workaround
>>
>> To deactivate:
>>  # echo 0 > /sys/devices/cpu/ht_bug_workaround
>
> If I put my simple-user hat and stare at this sysfs node, I'm not really
> becoming any smarter from looking at the name. HT bug? A hyper-threading
> bug?? I see the user forums going nuts already.
>
OK. We can call it perf_pmu_ht_bug_workaround to make this more explicit.

The other thing we will do in V4 is to make the file disappear if HT
is off because
the problem does not exist in that case.

> Instead of adding a sysfs node per CPU bug, I'm wondering whether adding
> a
>
>         /sys/devices/system/cpu/bugs
>
> file which gets a mask of bits to enable and disable workarounds would
> be much cleaner.
>
> x86 guys, what do you guys think?
>
> Such a scheme should be much more easily extensible in the future in
> case we want to add another workaround toggle.
>
> The hierarchy is not optimal either as it should be under
> "perf"-something but I don't think we have a perf sysfs node...
>
>> Results effective only once there is no more active
>> events.
>>
>> Reviewed-by: Stephane Eranian <eranian@google.com>
>> Signed-off-by: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
>> ---
>
> ...
>
>>  static DEVICE_ATTR(rdpmc, S_IRUSR | S_IWUSR, get_attr_rdpmc, set_attr_rdpmc);
>> +static DEVICE_ATTR(ht_bug_workaround, S_IRUSR | S_IWUSR, get_attr_xsu,
>> +                set_attr_xsu);
>>
>>  static struct attribute *x86_pmu_attrs[] = {
>>       &dev_attr_rdpmc.attr,
>> +     &dev_attr_ht_bug_workaround.attr,
>
> You should be adding this dynamically, only when running on Intel, i.e.
>
>         if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
>                 /* add bug_workaround attr */
>
> For an example, see amd_l3_attrs() in
> arch/x86/kernel/cpu/intel_cacheinfo.c
>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
