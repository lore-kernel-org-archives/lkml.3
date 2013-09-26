Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab3IZGFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:05:06 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:50194 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3IZGFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:05:03 -0400
MIME-Version: 1.0
In-Reply-To: <52435FE2.20805@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<fb67ff6fa01bde06aeab43c4a02da2923615e6ef.1379779777.git.viresh.kumar@linaro.org>
	<52435FE2.20805@linaro.org>
Date: Thu, 26 Sep 2013 11:35:01 +0530
Message-ID: <CAKohpokT12boxnnUJ=5Bd8tRh5VKvidd+kxQ6tF+pp1SLcgb4A@mail.gmail.com>
Subject: Re: [PATCH 16/21] cpuidle: avoid unnecessary kzalloc/free of struct cpuidle_device_kobj
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 03:42, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> On 09/22/2013 03:21 AM, Viresh Kumar wrote:
>> We always need to allocate struct cpuidle_device_kobj for all CPUs and so there
>> is no real need to have a pointer to it inside struct cpuidle_device.
>>
>> This patch makes a object instance of struct cpuidle_device_kobj inside struct
>> cpuidle_device instead of a pointer.
>>
>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>
> nack, it was made in purpose for kobject_init_and_add.
>
> see commit 728ce22b696f9f1404a74d7b2279a65933553a1b

Ahh.. sorry for missing that one :(

Now that I understand why it was introduced, I am thinking if
we can make hotplug path a bit fast? By not freeing sysfs stuff
and only hiding it for time being? And so we wouldn't be required
to do unnecessary initialisations while coming back?

Would that be worth it?
