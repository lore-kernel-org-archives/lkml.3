Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaEOFqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:46:22 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:59519 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaEOFqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:46:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponTH9X6AUX_0TJbRw0bUw5WQaE6oeDpGW9avTLifLGBCQ@mail.gmail.com>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
	<20140514150255.GA8330@amd.pavel.ucw.cz>
	<CAKohpo=MFxUHL22TxXPk4B=JX9AD3RGdgXPPGK9sD3GD6AEV+g@mail.gmail.com>
	<CAOqmu80j2q6hQLThVt60QkjqcZTXwJ6ddwDLvqBEW1ejrVh_hw@mail.gmail.com>
	<CAKohponWM+RxgK-50BXH-gk3-bX2no7NojT5-6ZRWJAtSizO7A@mail.gmail.com>
	<CAOqmu81C7A-bMQY3p5fsvk-4Y=S1yGZHw_Q=RbxCKxwR9fFz-w@mail.gmail.com>
	<CAKohpon+YbHx_P0oxkT5vSKVn30aZBddykgLLfyg5N3gPEXe6w@mail.gmail.com>
	<CAOqmu81sUqCTw_x2HZAjfQhzdH6aRMOPAy+i_HeScp2q8zTzuQ@mail.gmail.com>
	<CAKohponTH9X6AUX_0TJbRw0bUw5WQaE6oeDpGW9avTLifLGBCQ@mail.gmail.com>
Date: Thu, 15 May 2014 11:16:19 +0530
X-Google-Sender-Auth: TSvTon2yayz-U9tCY-1j3qdeBEg
Message-ID: <CAOqmu83ptKYHECdtLgEJLxbWa-VjxjKfw4dQo2gqQJP4doS_FQ@mail.gmail.com>
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

On Thu, May 15, 2014 at 11:07 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 15 May 2014 11:00, Inderpal Singh <inderpal.s@samsung.com> wrote:
>> On Thu, May 15, 2014 at 10:34 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> On 15 May 2014 10:22, Inderpal Singh <inderpal.s@samsung.com> wrote:
>>>
>>>> What i am saying that "what if we are not going to re-use again ? "
>>>
>>> That's what I said:
>>>
>>> Yes, it will keep occupying some space but there is only one instance
>>> of that per 'cluster' and is very much affordable instead of building it again..
>>>
>>> So, we may not need to free it.
>>
>> Its not just about cpufreq. There may be others using OPPs as well.
>> For example devfreq.
>
> And who is stopping these to use the already built ones? Exactly for
> this reason I have been saying that lets not free OPPs already built.
> Devfreq can simply use the ones built by cpufreq, even if cpufreq isn't
> using it anymore.

I think I did not make myself clear.
Devfreq will have its own opp table associated with its own device. It
does not uses the opp table of cpus.
Hence there may be need to free the table if driver (at least devfreq)
getting un-registered.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
