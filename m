Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763094Ab3DDEyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 00:54:43 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:59193 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab3DDEyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 00:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <515CBB98.4020607@semaphore.gr>
References: <ore61p9gvaic2j0fc083dpbd.1364970699079@email.android.com>
	<CAKohponUuwiQ9EiKq66Mgf7zZxonxHs=DNbhx=uydDVB5bed6w@mail.gmail.com>
	<3060957.HxB12olH3c@vostro.rjw.lan>
	<515CBB98.4020607@semaphore.gr>
Date: Thu, 4 Apr 2013 10:24:40 +0530
Message-ID: <CAKohpomV7uSS1suFKGiGJfGvvqodKHhvc_uO3WsR4jzUg+1o9g@mail.gmail.com>
Subject: Re: [PATCH v3 linux-next] cpufreq: ondemand: Calculate gradient of
 CPU load to early increase frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stratos,

On 4 April 2013 05:00, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> I tried to do some measurements simulating a CPU load with a loop that simply counts
> an integer. The first test simulates a CPU load that lasts 2 x sampling_rate = ~ 20000us.
> The second ~40000us and the third ~60000us.
> There are 5 runs in each test. In each run the benchmark program counts 20 times with
> early_demand off and 20 times with early_demand on and takes the average times.
>
> I run the benchmark program on 3.9-rc5 + early_demand patch. My CPU is the i7-3770 @ 3.40 GHz
>
> Please find below the results, and the benchmark code attached.
> Please note, that the idea of this patch is to push the CPU to max frequency few sampling
> periods (1 in most cases) earlier for a more responsive system.

Yes, your results show some improvements. BUT if performance is the only thing
we were looking for, then we will never use ondemand governor but performance
governor.

I suspect this little increase in performance must have increased power numbers
too (significantly). So, if you can get numbers in the form of power/performance
with and without your patch, it will be great.

--
viresh
