Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaGLDGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 23:06:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39503 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaGLDGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 23:06:49 -0400
Message-ID: <53C0A648.9080909@codeaurora.org>
Date: Fri, 11 Jul 2014 20:06:48 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Todd Poynor <toddpoynor@google.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] cpufreq: Don't destroy/realloc policy/sysfs on hotplug/suspend
References: <1404959850-11617-1-git-send-email-skannan@codeaurora.org> <1405052287-4744-1-git-send-email-skannan@codeaurora.org> <CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com>
In-Reply-To: <CAKohponB9feyh50p+dL5hyU1ffHAzHU59G-sYCrCm1AbHQe9hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 11:19 PM, Viresh Kumar wrote:

>
> Please make sure you take care of these issues:
> - suspend/resume
> - hotplug
> - module insert/remove
Ok, I was just at the current code. Does cpufreq_unregister_driver() 
even really work correctly as it stands?

It doesn't even seem to stop any of the governors/policies before it 
just set the cpufreq_driver pointer to NULL.

So, technically my v2 patch doesn't even make anything worse when it 
comes to unregistering the cpufreq driver.

Similar issues for unregister_governor too!

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
