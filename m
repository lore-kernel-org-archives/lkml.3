Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab3CEFWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 00:22:38 -0500
Received: from sema.semaphore.gr ([78.46.194.137]:48638 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750716Ab3CEFWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 00:22:36 -0500
Message-ID: <51358117.9060902@semaphore.gr>
Date: Tue, 05 Mar 2013 07:22:31 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] cpufreq: conservative: Fix sampling_down_factor
 functionality
References: <51351CC3.4010301@semaphore.gr> <CAOh2x=m0KLbjGKvLvTH7-yQb4SU5-v=-r4Ba3LSZz=NvfvO6mg@mail.gmail.com>
In-Reply-To: <CAOh2x=m0KLbjGKvLvTH7-yQb4SU5-v=-r4Ba3LSZz=NvfvO6mg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On 03/05/2013 02:23 AM, Viresh Kumar wrote:> Interesting. Because it was removed earlier and no body complained :)
> 
> I got following from Documentation:
> 
> sampling_down_factor: this parameter controls the rate at which the
> kernel makes a decision on when to decrease the frequency while running
> at top speed. When set to 1 (the default) decisions to reevaluate load
> are made at the same interval regardless of current clock speed. But
> when set to greater than 1 (e.g. 100) it acts as a multiplier for the
> scheduling interval for reevaluating load when the CPU is at its top
> speed due to high load. This improves performance by reducing the overhead
> of load evaluation and helping the CPU stay at its top speed when truly
> busy, rather than shifting back and forth in speed. This tunable has no
> effect on behavior at lower speeds/lower CPU loads.
> 
> And i believe we are supposed to check if we are at the top speed or not.
> Over that i believe the code should be like:
> 
> While setting speed to top speed, set the timer to delay * sampling_down_factor,
> so that we actually don't reevaluate the load. What do you say?
> 

I had the same thoughts, but I saw the comments in the code:

/*
 * Every sampling_rate, we check, if current idle time is less than 20%
 * (default), then we try to increase frequency Every sampling_rate *
 * sampling_down_factor, we check, if current idle time is more than 80%, then
 * we try to decrease frequency
 *

Also checking the code before the commit 8e677ce83bf41ba9c74e5b6d9ee60b07d4e5ed93 you may see that sampling down factor works in this way.
So, I decided to keep the original functionality (also down_skip was already there unused).

Regards,
Stratos

