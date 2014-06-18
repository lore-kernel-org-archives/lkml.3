Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbaFROlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:41:50 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:47007 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756901AbaFROlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:41:49 -0400
MIME-Version: 1.0
In-Reply-To: <53A1A4A9.4060301@nvidia.com>
References: <1403050362-20809-1-git-send-email-aplattner@nvidia.com>
	<CAKohpo=2fpi7GivgNGE+DgD3xPdku3WzKKD8+Ziz4gQ4P6pMxQ@mail.gmail.com>
	<53A1A4A9.4060301@nvidia.com>
Date: Wed, 18 Jun 2014 20:11:48 +0530
Message-ID: <CAKohpo=bGz97TJeY51M7k9VSHww=pk5TULEAROHRkp5x9-L-8w@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: unlock when failing cpufreq_update_policy()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Aaron Plattner <aplattner@nvidia.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 June 2014 20:09, Aaron Plattner <aplattner@nvidia.com> wrote:
> I assume you meant "return -ENODEV"?

Yeah, sorry :)

>>          down_write(&policy->rwsem);
>>
>> @@ -2279,10 +2277,10 @@ int cpufreq_update_policy(unsigned int cpu)
>>
>>          ret = cpufreq_set_policy(policy, &new_policy);
>>
>> +no_policy:
>
>
> 'no_policy' implied to me that policy was NULL, so this label should still
> be renamed to 'unlock'.  I'll send out a v2 that does this.

Yeah.
