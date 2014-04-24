Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaDXHrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:47:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56896 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaDXHrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140423163228.GC1243@e102568-lin.cambridge.arm.com>
References: <1398080958-21677-5-git-send-email-chander.kashyap@linaro.org>
	<1398245154-18771-1-git-send-email-chander.kashyap@linaro.org>
	<1398245154-18771-3-git-send-email-chander.kashyap@linaro.org>
	<20140423163228.GC1243@e102568-lin.cambridge.arm.com>
Date: Thu, 24 Apr 2014 13:17:07 +0530
Message-ID: <CANuQgHHMQ_SpO7jvbL7KDP0frK2_QFo8wvPwLrpsUFwPUQMt_g@mail.gmail.com>
Subject: Re: [Patch v2 2/4] driver: cpuidle: cpuidle-big-little: init driver
 for Exynos5420
From: Chander Kashyap <chander.kashyap@linaro.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        Chander Kashyap <k.chander@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 April 2014 22:02, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> On Wed, Apr 23, 2014 at 10:25:52AM +0100, Chander Kashyap wrote:
>> Add "samsung,exynos5420" compatible string to initialize generic
>> big-little cpuidle driver for Exynos5420.
>>
>> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> ---
>>  drivers/cpuidle/cpuidle-big_little.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle-big_little.c b/drivers/cpuidle/cpuidle-big_little.c
>> index b45fc62..d0fac53 100644
>> --- a/drivers/cpuidle/cpuidle-big_little.c
>> +++ b/drivers/cpuidle/cpuidle-big_little.c
>> @@ -170,7 +170,8 @@ static int __init bl_idle_init(void)
>>       /*
>>        * Initialize the driver just for a compliant set of machines
>>        */
>> -     if (!of_machine_is_compatible("arm,vexpress,v2p-ca15_a7"))
>> +     if (!of_machine_is_compatible("arm,vexpress,v2p-ca15_a7") &&
>> +             (!of_machine_is_compatible("samsung,exynos5420")))
>>               return -ENODEV;
>
> We should handle the string matching differently, we can't keep adding
> comparisons.

yes, that's true.


>
> Daniel raised the point already: what about the idle tables (data and
> number of states ?). TC2 has just a cluster state, and specific
> latencies, which are highly unlikely to be correct for this platform.
>

As of now only support for one state i.e. core power down.

As latencies are  concerned, need to fine tune.

Thanks again for the review.

> Lorenzo
>



-- 
with warm regards,
Chander Kashyap
