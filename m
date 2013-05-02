Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549Ab3EBSZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:25:16 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:50965 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761277Ab3EBSZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:25:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130502123033.GC22618@amd.pavel.ucw.cz>
References: <1367360914-23389-1-git-send-email-zoran.markovic@linaro.org>
	<20130501003058.GB20042@amd.pavel.ucw.cz>
	<CAMbhsRQkYFvOzDDn4zmbZAEsVs6iSy4mPVq5w=MzQ7p9STBDew@mail.gmail.com>
	<20130501105630.GA22552@amd.pavel.ucw.cz>
	<CAMbhsRTtYSLpAmB0hsanBH3ez4bm8BgbcH1xEBQsZSj4dc069g@mail.gmail.com>
	<20130502123033.GC22618@amd.pavel.ucw.cz>
Date: Thu, 2 May 2013 11:25:12 -0700
X-Google-Sender-Auth: LnrRe8XK7MHE0s5SSNsxqX5xAiM
Message-ID: <CAMbhsRSdk-z-67BEEd=zbWLR6=WXjpCk1uJky2ZEONS7FLcmGw@mail.gmail.com>
Subject: Re: [RFC PATCH] drivers: power: Add watchdog timer to catch drivers
 which lockup during suspend.
From: Colin Cross <ccross@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 5:30 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> > do BUG which
>> >> >    dumps stack of current task
>> >> >    kills current task
>> >> >
>> >> > Current task may very well be idle task; in such case you kill the
>> >> > machine. Sounds like you should be doing something else, like kill -9
>> >> > instead of BUG()?
>> >>
>> >> Not much else you can do, you are stuck part way into suspend with a
>> >> driver's suspend callback half executed.  All userspace tasks are
>> >> frozen, and the suspend task is blocked indefinitely.
>> >
>> > Yes, there's better option. Attempt killing the [a]suspend task,
>> > instead of killing the current task.
>>
>> That will leave you in a completely undefined state.  If you just kill
>> the task, you are likely to kill the synchronous suspend task, which
>> is the task that would resume your drivers and unfreeze tasks.  That
>> will leave you with no userspace tasks running, and much of your
>> hardware suspended.  How is that a useful result?  If you somehow
>
> So instead you kill random task? (BUG() from timer kills pretty much
> random task, right?)
>
> If you want to do panic(), do panic().

At least on ARM a BUG() in an interrupt or softirq always results in a
panic, but this can be switched to directly call panic.
