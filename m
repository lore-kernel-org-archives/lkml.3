Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965399Ab3E2JZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:25:13 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37202 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965344Ab3E2JZL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:25:11 -0400
MIME-Version: 1.0
In-Reply-To: <51A4D2CE.90604@intel.com>
References: <CADDKRnDH130wn8nVaT4xmCuEEcsGyBcjhj7pDjPMkeucUW+EWw@mail.gmail.com>
	<51A4D2CE.90604@intel.com>
Date: Wed, 29 May 2013 11:25:10 +0200
Message-ID: <CADDKRnAMyEud9RjCPN+1XsYC3SJbXF3N5OJ-v0g_J0p1TWyPBg@mail.gmail.com>
Subject: Re: [v3.10-rc] intel_pstate question
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rafael.j.wysocki@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/28 Dirk Brandewie <dirk.brandewie@gmail.com>:
> Hi Jörg,
>
>
> On 05/28/2013 08:02 AM, Jörg Otte wrote:
>>
>> Hi,
>>
>> the sysfs-interface of intel_pstate is different to that of the acpi
>> driver:
>> - intel_pstate shows current cpu-frequency in "cpuinfo_cur_freq" whereas
>>    the acpi counterpart uses "scaling_cur_freq".
>> - moreover cpuinfo_cur_freq is readable by root only, whereas
>>    scaling_cur_freq is world readable.
>>
>>    A monitoring tool must take care of theese differences.
>>    Is this intentional?
>>
>
> This is a side effect of the interface that intel_pstate presents to the
> cpufreq
> core.
>
> cpuinfo_cur_freq reports the value returned from the scaling driver.
>
> scaling_cur_freq reports the current frequency in the governors policy
> structure.
>
> intel_pstate has an internal governor so the core does not try to interpret
> the policy structure.
>
> I don't know why cpuinfo_cur_info is read-only root maybe Rafael knows the
> history.
>
Thank you Dirk, for the information!

Just another question: Now that processor 3a is supported, I am giving
pstate driver a try on my notebook. This is the first time I see frequencies
between above 2.5 and up to 3.1 GHz. With cpufreq driver I never saw that
frequencies.
So I think pstate driver uses turbo mode if appropriate (in contrast to
cpufreq). is this correct?

Thanks, Jörg
