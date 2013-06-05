Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab3FEWSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:18:03 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:59460 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab3FEWSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAME+o4kn=xBToxV2xfC5L0b5wVbQ27EA8+tDt9jT44BvBPeSTA@mail.gmail.com>
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org>
	<3006354.hOxNuWCXu4@vostro.rjw.lan>
	<CAME+o4kJYD2K_aL4xNi-jNP1Q8R+seDNZDwsGBhvU00ArR0Skg@mail.gmail.com>
	<1515063.BZy7p4GtyV@vostro.rjw.lan>
	<CAME+o4kn=xBToxV2xfC5L0b5wVbQ27EA8+tDt9jT44BvBPeSTA@mail.gmail.com>
Date: Wed, 5 Jun 2013 15:17:59 -0700
Message-ID: <CAME+o4mkBknj0jiUW=Z77fG1bJYy1jHF7=shNQ_ixeL_oJDjFg@mail.gmail.com>
Subject: Re: [RFC PATCHv2 1/2] drivers: power: Add watchdog timer to catch
 drivers which lockup during suspend/resume.
From: Zoran Markovic <zoran.markovic@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Colin Cross <ccross@android.com>, lkml <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Benoit Goby <benoit@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Todd Poynor <toddpoynor@google.com>, San Mehat <san@google.com>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

>>> We could do cancel_work_sync() as a recovery, but that call blocks until the
>>> running async task is flushed, which might never happen. So doing a panic()
>>> is pretty much the only option for recovering.
>>
>> Well, its usefulness is quite limited, then.  That said I'm still not convinced
>> that this actually is the case.
>
> It does block in my environment, AFAICS. Looking a bit further in the
> code, it looks like dpm_suspend() does an async_synchronize_full()
> which would wait for all async tasks to complete. This is a
> show-stopper because (under the circumstances) the assumption that
> every async suspend routine eventually completes doesn't hold.
>
> We could possibly select which async tasks to wait for, but this would
> add unnecessary complexity to a feature targeted for debugging. It
> seems that this approach - although sounding reasonable - needs to
> wait until we have a mechanism to cancel an async task.

Looks like the implementation of proposal for an async suspend +
wait_for_completion_timeout is quite complex due to above limitations.
How do we proceed from here? We have the following options:
1. Give up on the idea of having a suspend/resume watchdog.
2. Use the timer implementation (with possible modifications).
3. Wait for the implementation of (or implement) killing of an already
running async work.

Are there any other ideas floating around?

Thanks,
Zoran
