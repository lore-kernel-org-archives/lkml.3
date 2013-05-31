Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab3EaVNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:13:37 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:39049 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab3EaVNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:13:31 -0400
MIME-Version: 1.0
In-Reply-To: <1515063.BZy7p4GtyV@vostro.rjw.lan>
References: <1368221329-1841-1-git-send-email-zoran.markovic@linaro.org>
	<3006354.hOxNuWCXu4@vostro.rjw.lan>
	<CAME+o4kJYD2K_aL4xNi-jNP1Q8R+seDNZDwsGBhvU00ArR0Skg@mail.gmail.com>
	<1515063.BZy7p4GtyV@vostro.rjw.lan>
Date: Fri, 31 May 2013 14:13:30 -0700
Message-ID: <CAME+o4kn=xBToxV2xfC5L0b5wVbQ27EA8+tDt9jT44BvBPeSTA@mail.gmail.com>
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

>> We could do cancel_work_sync() as a recovery, but that call blocks until the
>> running async task is flushed, which might never happen. So doing a panic()
>> is pretty much the only option for recovering.
>
> Well, its usefulness is quite limited, then.  That said I'm still not convinced
> that this actually is the case.

It does block in my environment, AFAICS. Looking a bit further in the
code, it looks like dpm_suspend() does an async_synchronize_full()
which would wait for all async tasks to complete. This is a
show-stopper because (under the circumstances) the assumption that
every async suspend routine eventually completes doesn't hold.

We could possibly select which async tasks to wait for, but this would
add unnecessary complexity to a feature targeted for debugging. It
seems that this approach - although sounding reasonable - needs to
wait until we have a mechanism to cancel an async task.

Regards, Zoran
