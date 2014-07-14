Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaGNGZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:25:38 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:48960 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaGNGZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:25:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpokxmrFz+4x+V3MeEuKgnzQoETWLA_0aZHhhE6=+MvQP1Q@mail.gmail.com>
References: <1405314104-9688-1-git-send-email-xerofoify@gmail.com>
	<CAKohpokxmrFz+4x+V3MeEuKgnzQoETWLA_0aZHhhE6=+MvQP1Q@mail.gmail.com>
Date: Mon, 14 Jul 2014 02:25:29 -0400
Message-ID: <CAPDOMVj657n5eAztm_5Oogxn1j7v6faykqdJefs6MjD36sdBHg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix latency for cpufreq_info
From: Nick Krause <xerofoify@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 2:10 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 14 July 2014 10:31, Nicholas Krause <xerofoify@gmail.com> wrote:
>> This fixes the latency for the cpufreq policy to 1 million nanoseconds
>> that calls the function pxa_cpu_init for the member of the structure
>> called cpuinfo.transition_latency.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  drivers/cpufreq/pxa2xx-cpufreq.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
>> index e24269a..e08bb98 100644
>> --- a/drivers/cpufreq/pxa2xx-cpufreq.c
>> +++ b/drivers/cpufreq/pxa2xx-cpufreq.c
>> @@ -372,7 +372,7 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
>>         init_sdram_rows();
>>
>>         /* set default policy and cpuinfo */
>> -       policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
>> +       policy->cpuinfo.transition_latency = 1000, 000;
>
> Have you tried testing this at all? This patch wouldn't change anything.
> Still 1000 will get assigned to latency :)
>
> Get rid of the comma.
Sure , sorry about the comma. I am resending this patch to you fixed.
Cheers Nick
