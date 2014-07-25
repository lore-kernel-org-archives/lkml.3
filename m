Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaGYXG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:06:57 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:52235 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaGYXGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:06:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAMf-jS=pCKtOK6ZG=LWLGSJT9xCzCkiuARVskut4Wz+pARSsyw@mail.gmail.com>
References: <1405319337-11368-1-git-send-email-xerofoify@gmail.com>
	<CAKohpo=R4sjEGUFDt2yubfTQ+r1FO5RtFBYg8XROH-SYu90Zew@mail.gmail.com>
	<CAMf-jS=pCKtOK6ZG=LWLGSJT9xCzCkiuARVskut4Wz+pARSsyw@mail.gmail.com>
Date: Fri, 25 Jul 2014 19:06:54 -0400
Message-ID: <CAPDOMVi7bXziheE6LaCHjjGg-aPov5_8kSN-xGxedPzV=PRAEQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix latency for cpufreq_info
From: Nick Krause <xerofoify@gmail.com>
To: pramod gurav <pramod.gurav.etc@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 1:36 AM, pramod gurav
<pramod.gurav.etc@gmail.com> wrote:
> Viresh,
> Be careful when you ACK Nick's patches. He has confessed he has no
> idea how to build test a kernel. His patches are NOT AT ALL build
> tested. And some of his patches are being reverted for causing
> problems in build and all. He looks for FIXME and removes/edits the
> code as per the comments. Just be careful.
>
> On Mon, Jul 14, 2014 at 12:00 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 14 July 2014 11:58, Nicholas Krause <xerofoify@gmail.com> wrote:
>>> This fixes the latency for the cpufreq policy to 1 million nanoseconds
>>> that calls the function pxa_cpu_init for the member of the structure
>>> called cpuinfo.transition_latency.
>>>
>>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>> ---
>>>  drivers/cpufreq/pxa2xx-cpufreq.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
>>> index e24269a..e08bb98 100644
>>> --- a/drivers/cpufreq/pxa2xx-cpufreq.c
>>> +++ b/drivers/cpufreq/pxa2xx-cpufreq.c
>>> @@ -372,7 +372,7 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
>>>         init_sdram_rows();
>>>
>>>         /* set default policy and cpuinfo */
>>> -       policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
>>> +       policy->cpuinfo.transition_latency = 1000000;
>>>
>>>         /* Generate pxa25x the run cpufreq_frequency_table struct */
>>>         for (i = 0; i < NUM_PXA25x_RUN_FREQS; i++) {
>>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
> --
> Thanks and Regards
> Pramod


Pramod,
I learned how to do it today and Viresh checked this and it didn't build
so I sent him another fixed patch :). I am learning fast now and known
how to properly test my patches now.
Nick
