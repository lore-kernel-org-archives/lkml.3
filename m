Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaEOFaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:30:09 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:47144 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaEOFaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:30:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon+YbHx_P0oxkT5vSKVn30aZBddykgLLfyg5N3gPEXe6w@mail.gmail.com>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
	<20140514150255.GA8330@amd.pavel.ucw.cz>
	<CAKohpo=MFxUHL22TxXPk4B=JX9AD3RGdgXPPGK9sD3GD6AEV+g@mail.gmail.com>
	<CAOqmu80j2q6hQLThVt60QkjqcZTXwJ6ddwDLvqBEW1ejrVh_hw@mail.gmail.com>
	<CAKohponWM+RxgK-50BXH-gk3-bX2no7NojT5-6ZRWJAtSizO7A@mail.gmail.com>
	<CAOqmu81C7A-bMQY3p5fsvk-4Y=S1yGZHw_Q=RbxCKxwR9fFz-w@mail.gmail.com>
	<CAKohpon+YbHx_P0oxkT5vSKVn30aZBddykgLLfyg5N3gPEXe6w@mail.gmail.com>
Date: Thu, 15 May 2014 11:00:05 +0530
X-Google-Sender-Auth: 31tXnGKLRAg-B4UHbt56P2vv7hc
Message-ID: <CAOqmu81sUqCTw_x2HZAjfQhzdH6aRMOPAy+i_HeScp2q8zTzuQ@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
From: Inderpal Singh <inderpal.s@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Nishanth Menon <nm@ti.com>, Pavel Machek <pavel@ucw.cz>,
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

On Thu, May 15, 2014 at 10:34 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 15 May 2014 10:22, Inderpal Singh <inderpal.s@samsung.com> wrote:
>
>> What i am saying that "what if we are not going to re-use again ? "
>
> That's what I said:
>
> Yes, it will keep occupying some space but there is only one instance
> of that per 'cluster' and is very much affordable instead of building it again..
>
> So, we may not need to free it.

Its not just about cpufreq. There may be others using OPPs as well.
For example devfreq.
The OPPs for cpu devices may be used again but for others I am not sure.

>
>> Also, I feel the driver who created the opp table at its registration
>> time should free it at its unregistration. Isn't it true in general?
>
> Probably case to case basis. You must free resources for two reasons:
> - They are not lost, like memory leak ..
> - They can be used by others ..
>
> And both these doesn't happen in this case. OPP tables can be used
> by any other framework and is more or less a core thing..
>
> Now, with this discussion I have another idea here..
>
> Why don't we build these tables automatically on boot from some core
> code, rather than asking drivers to do it ? That will get rid of duplication
> from all drivers and would also reduce confusion
>

I also felt the same at least for OPPs of cpu devices.

> @Rafael/Nishanth ??
>
> If things look right, then I can write a patch for fixing it quickly...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
