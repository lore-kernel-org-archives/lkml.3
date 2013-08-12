Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3HLHKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 03:10:49 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:42577 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab3HLHKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:10:48 -0400
Date: Mon, 12 Aug 2013 09:10:42 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/44] cpufreq: at32ap: Use generic cpufreq routines
Message-ID: <20130812071042.GA30670@samfundet.no>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
 <c70729588f2f21d10fa5d53e5189890af4248a93.1376116345.git.viresh.kumar@linaro.org>
 <20130810082333.GA27640@samfundet.no>
 <CAKohpon63d40c8eGKqY9EHZhb18ipKHhvBffo=buLLpP=CP0rA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpon63d40c8eGKqY9EHZhb18ipKHhvBffo=buLLpP=CP0rA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 12 Aug 2013 11:37:45 +0530 or thereabout, Viresh Kumar wrote:
> On 10 August 2013 13:53, Hans-Christian Egtvedt <egtvedt@samfundet.no> wrote:
>> Around Sat 10 Aug 2013 12:14:07 +0530 or thereabout, Viresh Kumar wrote:
>>> Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
>>> and .attr. So its better if we have generic routines for them which can be used
>>> by cpufreq drivers then.
>>>
>>> This patch uses these generic routines for this driver.
>>
>> Nice, thanks for cleaning up (-:
>>
>>> Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
>>> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>>
>> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> 
> Thanks for your Ack but I have to NACK it :)
> 
> My patch was wrong.. It was based on the assumption that everybody who
> had implemented a .target() also implements a frequency table and exposes
> it.. And the generic routines I have exposed depend on that frequency table.
> And this cpufreq driver doesn't expose that freq table...

Right, my bad, I just looked at the code flow and saw that the generic path
did pretty much the same as the AVR32 implementation. Didn't consider the
table part as missing.

> And so this patch is dropped :(
> 

Ok, AVR32 driver should expose a frequency table then, which is quite simple.

-- 
mvh
Hans-Christian Egtvedt
