Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaEOEw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:52:57 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:41807 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaEOEwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:52:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponWM+RxgK-50BXH-gk3-bX2no7NojT5-6ZRWJAtSizO7A@mail.gmail.com>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
	<20140514150255.GA8330@amd.pavel.ucw.cz>
	<CAKohpo=MFxUHL22TxXPk4B=JX9AD3RGdgXPPGK9sD3GD6AEV+g@mail.gmail.com>
	<CAOqmu80j2q6hQLThVt60QkjqcZTXwJ6ddwDLvqBEW1ejrVh_hw@mail.gmail.com>
	<CAKohponWM+RxgK-50BXH-gk3-bX2no7NojT5-6ZRWJAtSizO7A@mail.gmail.com>
Date: Thu, 15 May 2014 10:22:53 +0530
X-Google-Sender-Auth: a0XYIVTz_cKG1fFXBZEkItLZ86Y
Message-ID: <CAOqmu81C7A-bMQY3p5fsvk-4Y=S1yGZHw_Q=RbxCKxwR9fFz-w@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
From: Inderpal Singh <inderpal.s@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>,
        "[Chander Kashyap" <chander.kashyap@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chander Kashyap <k.chander@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 10:06 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 15 May 2014 10:02, Inderpal Singh <inderpal.s@samsung.com> wrote:
>> I feel freeing of opps are needed at least at the driver unregistration
>> time, like we free cpufreq_table.
>> Otherwise it amounts to memory leak unless we assume that the same driver is
>> going to re-register and re-use the same opps.
>
> Its memory leak only if we have lost the pointer to allocated memory, which
> we haven't. Yes, it will keep occupying some space but there is only
> one instance
> of that per 'cluster' and is very much affordable instead of building it again..
>
> There is a high chance that it will be used again by this or any other driver,
> cpufreq or outside of it.
>
> But, yes I do agree that the OPPs not added from dts, i.e. added from
> platform should be freed when they don't make a sense. But that's a different
> issue altogether.

What i am saying that "what if we are not going to re-use again ? " I
am not sure if its practical.
Also, I feel the driver who created the opp table at its registration
time should free it at its unregistration. Isn't it true in general?


> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
