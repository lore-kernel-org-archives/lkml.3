Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3GXIHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:07:18 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:60086 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3GXIHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:07:09 -0400
MIME-Version: 1.0
In-Reply-To: <51EF8590.7030405@samsung.com>
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
	<1374146275-5758-2-git-send-email-cw00.choi@samsung.com>
	<CAKohpo=oTsEjzi_51UaZ8ww8UEfZ6hwKAnu9rFgGBkt=TfHi8A@mail.gmail.com>
	<51EF2D06.7000704@samsung.com>
	<CAKohpok7B6DaqFPWZcODEgK5GRSoAQYZ27-h2=AQ1HBBP4gH8Q@mail.gmail.com>
	<51EF8590.7030405@samsung.com>
Date: Wed, 24 Jul 2013 13:37:08 +0530
Message-ID: <CAKohpom19C7JHSX6w31pSDrwcAR_PZn1HzP0Jui5iZL=bALDPQ@mail.gmail.com>
Subject: Re: [PATCH 1/3 v6] cpufreq: Add debugfs directory for cpufreq
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

I just realized I missed answering few questions:

On 24 July 2013 13:13, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> On 07/24/2013 02:05 PM, Viresh Kumar wrote:
>> On 24 July 2013 06:55, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>>> On 07/22/2013 07:11 PM, Viresh Kumar wrote:
>>>> On 18 July 2013 16:47, Chanwoo Choi <cw00.choi@samsung.com> wrote:

>>>>> +static void cpufreq_move_debugfs_dir(struct cpufreq_policy *policy,
>>>>> +                                    unsigned int new_cpu)
>>>>> +{
>>>>> +       struct dentry *old_entry, *new_entry;
>>>>> +       char new_dir_name[CPUFREQ_NAME_LEN];
>>>>> +       unsigned int j, old_cpu = policy->cpu;
>>>>> +
>>>>> +       if (!policy->cpu_debugfs[new_cpu])
>>>>> +               return;
>>>>> +
>>>>> +       /*
>>>>> +        * Remove symbolic link of debugfs directory except for debugfs
>>>>> +        * directory of old_cpu.
>>>>> +        */
>>>>> +       for_each_present_cpu(j) {
>>>>> +               if (old_cpu == j)
>>>>> +                       continue;
>>>>> +
>>>>> +               debugfs_remove(policy->cpu_debugfs[j]);
>>>>
>>>> Why you need this? We aren't removing the earlier dentry at all here.
>>
>> haven't answered this.
>
> The debugfs entry of 'old_cpu' include child debugfs file(e.g., load_table)
> If cpu is last user of policy and core call __cpufre_remove_dev() to remove last cpu,
> core call cpufreq_move_debugfs_dir(). I have to move the data of debugfs directory/file and
> child data for 'old_cpu' to debugfs directory for 'new_cpu'.
>
> If I remove earlier dentry of 'old_cpu', I can't get the child debugfs dir/file.
> So I didn't remove the earlier dentry of 'old_cpu'.

Okay.. The original question was: why do you need to remove & add
entries or links for cpus other than policy->cpu? Because we are renaming
the entry, wouldn't that work straight away?
