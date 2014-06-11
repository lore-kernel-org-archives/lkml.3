Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaFKVpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:45:15 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:47955 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaFKVpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:45:14 -0400
MIME-Version: 1.0
In-Reply-To: <00b401cf85bd$b4851f10$1d8f5d30$@net>
References: <1402490012-19969-1-git-send-email-stratosk@semaphore.gr>
	<009b01cf857a$d5032090$7f0961b0$@net>
	<539862DB.9060905@semaphore.gr>
	<00a001cf8586$24eb5c70$6ec21550$@net>
	<CAJZ5v0hEFp8sQH3iB6SUeVVEmdYA6ZK1kvc9NM+7sbS-LTW6nQ@mail.gmail.com>
	<00b401cf85bd$b4851f10$1d8f5d30$@net>
Date: Wed, 11 Jun 2014 23:45:13 +0200
X-Google-Sender-Auth: TEmdUJxyuSCjxQ3eCqUuiWVaLPs
Message-ID: <CAJZ5v0jPPkWCZBCTKazNJsK8m4aNB-1C6GKtUOmOUt+v_CV+WQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: intel_pstate: Fix rounding of core_pct
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Doug Smythies <dsmythies@telus.net>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
        Stratos Karafotis <stratosk@semaphore.gr>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, viresh.kumar@linaro.org,
        dirk.j.brandewie@intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 11:40 PM, Doug Smythies <dsmythies@telus.net> wrote:
>
>
> -----Original Message-----
> From: rjwysocki@gmail.com [mailto:rjwysocki@gmail.com] On Behalf Of Rafael J. Wysocki
> Sent: June-11-2014 11:29
> To: Doug Smythies
> Cc: Stratos Karafotis; linux-pm@vger.kernel.org; Linux Kernel Mailing List; Rafael J. Wysocki; viresh.kumar@linaro.org; dirk.j.brandewie@intel.com
> Subject: Re: [PATCH] cpufreq: intel_pstate: Fix rounding of core_pct
>
> On 2014.06.11 11:29 Rafael J. Wysocki wrote:
>> On Wed, Jun 11, 2014 at 5:02 PM, Doug Smythies <dsmythies@telus.net> wrote:
>>> On 2104.06.11 07:08 Stratos Karafotis wrote:
>>>> On 11/06/2014 04:41 μμ, Doug Smythies wrote:
>>>>
>>>> No.
>>>>
>>>> The intent was only ever to round properly the pseudo floating point result of the divide.
>>>> It was much more important (ugh, well 4 times more) when FRACBITS was still 6, which also got changed to 8 in a recent patch.
>>>>
>>>
>>> Are you sure?
>>>
>>> Yes.
>>>
>>>> This rounding was very recently added.
>>>> As far as I can understand, I don't see the meaning of this rounding, as is.
>>>> Even if FRAC_BITS was 6, I think it would have almost no improvement in
>>>> calculations.
>>>
>>> Note: I had not seen this e-mail when I wrote a few minutes ago:
>>>
>>> You may be correct.
>>> If Dirk agrees, I will re-analyse the entire driver for rounding effects soon.
>
>> Well, can you please do it if that's not a problem?
>
> Yes, of course, but it is a matter of priorities. All I meant by the above comment was that we might be able to forget about the remainder and just do a mindless divide, but leaving it as it is now does no harm in the meantime.
>
> Myself, I consider the issue of excessive deferred timer times to be a much higher priority (see my on-list e-mail from Monday). Correct me if I am wrong.
> Even without the "excessive" part, and for a 250 Hz kernel, the current kick in point can be hit routinely, unduly biasing the CPU frequency downwards.
> A random example (250 Hz kernel): 23% load at 25 Hertz load / sleep frequency for 300 total seconds.
>
> Duration histrogram:
>
> Occurrences duration (seconds)
>      16 0.044
>      39 0.024
>      45 0.028
>      46 0.016
>      48 0.032
>      61 0.036
>     166 0.012
>     198 0.020
>    7166 0.040
>
> Where you can see that the majority of the time the duration is such that the code will force the CPU frequency downwards. It runs at minimum pstate instead of maximum pstate where it should be.

I see.

What would you suggest to do to address this problem, then?

Rafael
