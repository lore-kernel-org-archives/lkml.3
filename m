Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab3DDGsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 02:48:19 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:37740 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763528Ab3DDGsQ (ORCPT
	<rfc822;	linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 02:48:16 -0400
Date: Thu, 04 Apr 2013 09:47:57 +0300
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
Message-ID: <c47p1i8x8eiep3wulmq44fxd.1365058077739@email.android.com>
From: stratosk <stratosk@semaphore.gr>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r346mKhe000831

Hi Viresh,

I never use performance governor, but I want improved performance with ondemand.

Why do you suspect significant increased power? With ondemand  the CPU will go down to lowest freq as soon as the load will decreased. And the measurement shows that the CPU load will decrease faster (because of faster calculation).

I build and distribute a 3.0.y kernel for a smart phone arm cortex A8. There are about 10000 installations with early_demand included. Nobody noticed increased power.

Though, I'm not able to provide numbers in the form of power.

Thanks,
Stratos

Viresh Kumar <viresh.kumar@linaro.org> wrote:

>Hi Stratos,
>
>On 4 April 2013 05:00, Stratos Karafotis <stratosk@semaphore.gr> wrote:
>> I tried to do some measurements simulating a CPU load with a loop that simply counts
>> an integer. The first test simulates a CPU load that lasts 2 x sampling_rate = ~ 20000us.
>> The second ~40000us and the third ~60000us.
>> There are 5 runs in each test. In each run the benchmark program counts 20 times with
>> early_demand off and 20 times with early_demand on and takes the average times.
>>
>> I run the benchmark program on 3.9-rc5 + early_demand patch. My CPU is the i7-3770 @ 3.40 GHz
>>
>> Please find below the results, and the benchmark code attached.
>> Please note, that the idea of this patch is to push the CPU to max frequency few sampling
>> periods (1 in most cases) earlier for a more responsive system.
>
>Yes, your results show some improvements. BUT if performance is the only thing
>we were looking for, then we will never use ondemand governor but performance
>governor.
>
>I suspect this little increase in performance must have increased power numbers
>too (significantly). So, if you can get numbers in the form of power/performance
>with and without your patch, it will be great.
>
>--
>viresh
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
