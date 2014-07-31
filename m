Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaGaUiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:38:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50358 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaGaUiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:38:52 -0400
Message-ID: <53DAA95B.2040505@codeaurora.org>
Date: Thu, 31 Jul 2014 13:38:51 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lenny Szubowicz <lszubowi@redhat.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem
 to be held for duration of changing governors [v2]
References: <1406634362-811-1-git-send-email-prarit@redhat.com> <2066166.pXm4lKLOID@vostro.rjw.lan> <53DA8389.80804@redhat.com> <1917362.abr2Y4p7vh@vostro.rjw.lan> <53DA8A41.2030601@redhat.com> <53DAA60B.6040802@codeaurora.org> <53DAA749.5080506@redhat.com>
In-Reply-To: <53DAA749.5080506@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 01:30 PM, Prarit Bhargava wrote:
>
>
> On 07/31/2014 04:24 PM, Saravana Kannan wrote:
>>
>> Prarit,
>>
>> I'm not an expert on sysfs locking, but I would think the specific sysfs lock
>> would depend on the file/attribute group. So, can you please try to hotplug a
>> core in/out (to trigger the POLICY_EXIT) and then read a sysfs file exported by
>> the governor? scaling_governor doesn't cut it since that file is not removed on
>> policy exit event to governor. If it's ondemand, try reading/write it's sampling
>> rate file.
>
> Thanks Saravana -- will do.  I will get back to you shortly on this.
>

Thanks. Btw, in case you weren't already aware of it. You'll have to 
hoplug out all the CPUs in a cluster to trigger a POLICY_EXIT for that 
cluster/policy.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
