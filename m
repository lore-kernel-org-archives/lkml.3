Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaEOGK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:10:59 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:51340 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaEOGK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:10:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=mYH1f69B+dHwQR71Qmpi7a07rWhQ=up-9zriY9hOFng@mail.gmail.com>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
	<20140514150255.GA8330@amd.pavel.ucw.cz>
	<CAKohpo=MFxUHL22TxXPk4B=JX9AD3RGdgXPPGK9sD3GD6AEV+g@mail.gmail.com>
	<CAOqmu80j2q6hQLThVt60QkjqcZTXwJ6ddwDLvqBEW1ejrVh_hw@mail.gmail.com>
	<CAKohponWM+RxgK-50BXH-gk3-bX2no7NojT5-6ZRWJAtSizO7A@mail.gmail.com>
	<CAOqmu81C7A-bMQY3p5fsvk-4Y=S1yGZHw_Q=RbxCKxwR9fFz-w@mail.gmail.com>
	<CAKohpon+YbHx_P0oxkT5vSKVn30aZBddykgLLfyg5N3gPEXe6w@mail.gmail.com>
	<CAOqmu81sUqCTw_x2HZAjfQhzdH6aRMOPAy+i_HeScp2q8zTzuQ@mail.gmail.com>
	<CAKohponTH9X6AUX_0TJbRw0bUw5WQaE6oeDpGW9avTLifLGBCQ@mail.gmail.com>
	<CAOqmu83ptKYHECdtLgEJLxbWa-VjxjKfw4dQo2gqQJP4doS_FQ@mail.gmail.com>
	<CAKohpo=mYH1f69B+dHwQR71Qmpi7a07rWhQ=up-9zriY9hOFng@mail.gmail.com>
Date: Thu, 15 May 2014 11:40:57 +0530
X-Google-Sender-Auth: VUlyvXjbPmkT-qgoL0UuASgbxc4
Message-ID: <CAOqmu82rYWomE6n=vEFk97tiS0Da4mZSFdvO5zVbApRAoS2LNA@mail.gmail.com>
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

On Thu, May 15, 2014 at 11:31 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 15 May 2014 11:16, Inderpal Singh <inderpal.s@samsung.com> wrote:
>> I think I did not make myself clear.
>
> Probably I was the one who got confused :)
>
>> Devfreq will have its own opp table associated with its own device. It
>> does not uses the opp table of cpus.
>> Hence there may be need to free the table if driver (at least devfreq)
>> getting un-registered.
>
> We may have an unregister routine routine, I am not arguing about that.
> But we don't need to call that for CPU's opp, that's it.. For devices it might
> make sense to free memory.

Yes the provision should be there in the OPP framework and let the
individual drivers decide whether to invoke or not.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
