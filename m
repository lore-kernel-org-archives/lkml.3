Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaGaXsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 19:48:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35575 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbaGaXsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 19:48:02 -0400
Message-ID: <53DAD5B0.3070500@codeaurora.org>
Date: Thu, 31 Jul 2014 16:48:00 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v4 3/5] cpufreq: Don't destroy/realloc policy/sysfs on
 hotplug/suspend
References: <1406250448-470-1-git-send-email-skannan@codeaurora.org> <1406250448-470-4-git-send-email-skannan@codeaurora.org> <3141717.0s1tLjazMZ@vostro.rjw.lan>
In-Reply-To: <3141717.0s1tLjazMZ@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 02:56 PM, Rafael J. Wysocki wrote:
> On Thursday, July 24, 2014 06:07:26 PM Saravana Kannan wrote:
>> This patch simplifies a lot of the hotplug/suspend code by not
>> adding/removing/moving the policy/sysfs/kobj during hotplug and just leaves
>> the cpufreq directory and policy in place irrespective of whether the CPUs
>> are ONLINE/OFFLINE.
>
> I'm still quite unsure how this is going to work with the real CPU hot-remove
> that makes the entire sysfs cpu directories go away.  Can you please explain
> that?

Sure. Not a problem. I just wanted to make sure you had a chance to look 
at the code first.

Physical hot-remove triggers a "remove" for all the  registered 
subsys_interfaces for that CPU (after going through a couple of 
functions). So, when that happens, the cpufreq subsys_interface remove 
for that CPU gets called. At that point, I clean up that CPU's SW states 
as if it was never plugged in from the start. If that CPU was the owner 
of the sysfs directory, I move it over to a different CPU.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
