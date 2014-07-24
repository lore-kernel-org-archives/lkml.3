Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbaGXDCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 23:02:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47516 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758563AbaGXDCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 23:02:17 -0400
Message-ID: <53D07737.70904@codeaurora.org>
Date: Wed, 23 Jul 2014 20:02:15 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org> <16164926.ZsJxe6UV3e@vostro.rjw.lan>
In-Reply-To: <16164926.ZsJxe6UV3e@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 03:02 PM, Rafael J. Wysocki wrote:
> On Wednesday, July 09, 2014 07:37:30 PM Saravana Kannan wrote:
>> Preliminary patch. Not tested. Just sending out to give an idea of what I'm
>> looking to do. Expect a lot more simplification when it's done.
>>
>> Benefits:
>> * A lot more simpler code.
>> * Less stability issues.
>> * Suspend/resume time would improve.
>> * Hotplug time would improve.
>> * Sysfs file permissions would be maintained.
>> * More policy settings would be maintained across suspend/resume.
>> * cpufreq stats would be maintained across hotplug for all CPUs.
>
> One problem.  The real hotplug (when the CPU actually goes away) depends on
> offline removing all that stuff for it.  How are you going to address that?
>

Ok, I think I've figured this out. But one question. Is it possible to 
physically remove one CPU in a bunch of "related cpus" without also 
unplugging the rest? Put another way, can you unplug one core from a 
cluster?

It's not too hard to support that too, but if it's not a realistic case, 
I would rather not write code for that.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
