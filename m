Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3FKFGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 01:06:25 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:55123 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3FKFGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 01:06:23 -0400
MIME-Version: 1.0
In-Reply-To: <51B5C2E4.9060400@samsung.com>
References: <1370419882-16831-1-git-send-email-cw00.choi@samsung.com>
	<CAKohpon6fgft2KZgy3-w5TxDz=5JsVHhNdTPTF7ZUq9K-kGc3w@mail.gmail.com>
	<51B5C2E4.9060400@samsung.com>
Date: Tue, 11 Jun 2013 10:36:22 +0530
Message-ID: <CAKohpokSt1=cbeYFo-U_DF5Mr8WOFDkkQbyaHh5DqR0OHh+S7A@mail.gmail.com>
Subject: Re: [RESEND][PATCH] cpufreq: stats: Add 'load_table' sysfs file to
 show accumulated data of CPU
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2013 17:43, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> On 06/07/2013 07:23 PM, Viresh Kumar wrote:
>> On 5 June 2013 13:41, Chanwoo Choi <cw00.choi@samsung.com> wrote:

> 1301500082290 800000 61 11 1 43
>
> ...
>
> When 1301500082290 ns:
> cpu0's busy_cpu_threshold : 32 = 64 * (800000/1600000)

s/64/61 :)

>> How are you getting loads different for all your cpus? I believe you
>> are just recording these values for policy->cpu and all cpus share
>> same policy on your platform.
>>
> I got the Per-CPU load by using cpufreq_notify_transition().
> when cpufreq governor call dbs_check_cpu().

I forgot to remove this line in my earlier reply. I understood this towards
the end of patch.

>>> +#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
>>> +       struct cpufreq_freqs freqs;
>>> +#endif
>> Why do you need this to be global?
> I'll remove global variable and move 'freqs' in some structure.

??

You can just make it a local variable in the only function it is used.

TIP: Always place a blank line before and after your reply to kernel
mails, this makes it much more readable.
