Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938AbaFNSKL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 14:10:11 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:40036 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754758AbaFNSKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 14:10:09 -0400
Message-ID: <539C8FFD.9030607@semaphore.gr>
Date: Sat, 14 Jun 2014 21:10:05 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Smythies <dsmythies@telus.net>,
        "'Dirk Brandewie'" <dirk.brandewie@gmail.com>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Dirk Brandewie'" <dirk.j.brandewie@intel.com>
CC: linux-pm@vger.kernel.org, "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] cpufreq: intel_pstate: Avoid duplicate call of intel_pstate_get_scaled_busy
References: <53962067.4060504@semaphore.gr> <53972CE1.1060209@gmail.com> <539731D1.6040504@semaphore.gr> <000b01cf87e7$b06afb30$1140f190$@net>
In-Reply-To: <000b01cf87e7$b06afb30$1140f190$@net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/06/2014 06:45 μμ, Doug Smythies wrote:
> I am sorry to be late chiming in on this one.
> 
> On 2014.06.10 09:27 Stratos Karafotis wrote:
>> On 10/06/2014 07:05 μμ, Dirk Brandewie wrote:
>> On 06/09/2014 02:00 PM, Stratos Karafotis wrote:
>>> Store busy_scaled value to avoid to duplicate call of
>>> intel_pstate_get_scaled_busy on every sampling interval.
>>>
>>>
>>> The second call *only* happens if the tracepoint is being used otherwise
>>> the whole function call to  trace_pstate_sample() is a noop.
> 
>> Yes, I'm sorry, I forgot to add this in my changelog. I have written this
>> in cover letter.
>> I made this change mostly to support patch 3/7.
> 
>>> This makes the code less readable IMHO the reader is left wondering
>>> how cpu->sample.busy_scaled was set in intel_pstate_adjust_busy_pstate()
>>>
> 
>> I agree that the the original code is more readable. If we don't care
>> about the small overhead when tracing is on and forget patch 3/7,
>> of course the original code is by far better.
> 
> Actually, when reading the code, I found it odd to call the function
> twice.
> 
> However by far the much more important issue here, in my opinion,
> is that if one is using the tracepoint stuff, then the second call
> to intel_pstate_get_scaled_busy can give a different result than
> the first call. Why? Because "cpu->pstate.current_pstate" may have
> changed between the two calls.
> 
> In the end the user (me in this case) of the tracepoint stuff can
> end up pulling (what's left of) their hair out and going around in
> circles attempting to figure out why doing the so simple math by
> hand doesn't seem to agree with the tracepoint data.

:)

> As a side note: I am now pulling the tracepoint data into a
> spreadsheet and calculating what "scaled" should be myself.
> 

I think you are right. Tracepoint data might be inconsistent.
I will re-submit this patch in v2 series, updating the changelog.

Thanks for pointing this out!

Stratos

