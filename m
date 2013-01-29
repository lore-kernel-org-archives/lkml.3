Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab3A2Oa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:30:26 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:40112 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab3A2OaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:30:24 -0500
MIME-Version: 1.0
In-Reply-To: <2215618.GPIWS1OcnB@vostro.rjw.lan>
References: <d6827976a56d429848ab8ababa2779a21c68d65f.1359434113.git.viresh.kumar@linaro.org>
	<2215618.GPIWS1OcnB@vostro.rjw.lan>
Date: Tue, 29 Jan 2013 20:00:23 +0530
Message-ID: <CAKohpomDtasshcO53eD0kR1c3aO+ePC5pAK_mGjJn1EKAMBf_w@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Set policy->related_cpus to atleast policy->cpus
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: inderpal.singh@linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 January 2013 17:21, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, January 29, 2013 10:09:59 AM Viresh Kumar wrote:
>> With the addition of following patch, related_cpus is required to be set by
>> cpufreq platform drivers:
>>
>> commit c1070fd743533efb54e98142252283583f379190
>> Author: Viresh Kumar <viresh.kumar@linaro.org>
>> Date:   Mon Jan 14 13:23:04 2013 +0000
>>
>>     cpufreq: Simplify cpufreq_add_dev()
>>
>
> I've dropped this one in the meantime.
>
> Can you please fold the $subject patch into "cpufreq: Simplify cpufreq_add_dev()"
> and post the result instead?  That surely will be less confusing?

Okay. I will squash this one with cpufreq_add_dev() one + following line:

diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index 8ff26af..fc714a6 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -189,7 +189,6 @@ static int spear_cpufreq_init(struct cpufreq_policy *policy)
        policy->cur = spear_cpufreq_get(0);

        cpumask_copy(policy->cpus, topology_core_cpumask(policy->cpu));
-       cpumask_copy(policy->related_cpus, policy->cpus);

        return 0;
 }


Also, because you are happy loosing your commit history in linux-next,
you can drop
the patch that i have reverted as 2/2 of this set.

I will resend the rest again.
