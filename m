Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaGPTmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:42:52 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:32817 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaGPTms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:42:48 -0400
Message-ID: <53C6D5B6.808@codeaurora.org>
Date: Wed, 16 Jul 2014 12:42:46 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 1/2] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org> <1405464473-3916-2-git-send-email-skannan@codeaurora.org> <53C68C54.3010900@gmail.com> <CAKohpokLzMbzr4kdL6wCL7MZgnVe0CQhbJHKL5wWeETH1YwEOg@mail.gmail.com>
In-Reply-To: <CAKohpokLzMbzr4kdL6wCL7MZgnVe0CQhbJHKL5wWeETH1YwEOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 08:28 AM, Viresh Kumar wrote:
> On 16 July 2014 19:59, Dirk Brandewie <dirk.brandewie@gmail.com> wrote:
>> stop_cpu() only needs to be called during __cpufreq_remove_dev_prepare() no
>> where else.
>
> Oh, thanks for reminding us..
>
> Look at this Saravana:
> 367dc4a cpufreq: Add stop CPU callback to cpufreq_driver interface
>

I'll only get called at the same time as it is called today. 
__cpufreq_remove_dev_prepare is now renamed to __cpufreq_remove_dev. And 
this function is called from there.

The only time stop does get called is when __cpufreq_remove_dev is 
called on the last CPU of a policy. So, functionally it's identical.

Btw, I already added logs to all cpufreq driver ops and checked the 
calls come in the same order with and without my changes.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
