Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbaIECL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 22:11:26 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62826 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbaIECLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 22:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140904175450.GB18411@ld-irv-0074>
References: <1409788535-28264-1-git-send-email-computersforpeace@gmail.com>
	<20140904071412.GA29832@amd>
	<20140904175450.GB18411@ld-irv-0074>
Date: Thu, 4 Sep 2014 19:11:23 -0700
X-Google-Sender-Auth: jOmPODd2FH5fRf3AnC2F29gXJsk
Message-ID: <CAJFHJroY_uBdRPVBPgCggchpAQ1n+jb=QjzNvy0cP-WLmsAPNA@mail.gmail.com>
Subject: Re: [PATCH] PM / sleep: add configurable delay for pm_test
From: Chirantan Ekbote <chirantan@chromium.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 10:54 AM, Brian Norris
<computersforpeace@gmail.com> wrote:
> On Thu, Sep 04, 2014 at 09:14:12AM +0200, Pavel Machek wrote:
>> > When CONFIG_PM_DEBUG=y, we provide a sysfs file (/sys/power/pm_test) for
>> > selecting one of a few suspend test modes, where rather than entering a
>> > full suspend state, the kernel will perform some subset of suspend
>> > steps, wait 5 seconds, and then resume back to normal operation.
>> >
>> > This mode is useful for (among other things) observing the state of the
>> > system just before entering a sleep mode, for debugging or analysis
>> > purposes. However, a constant 5 second wait is not sufficient for some
>> > sorts of analysis; for example, on an SoC, one might want to use
>> > external tools to probe the power states of various on-chip controllers
>> > or clocks.
>>
>> When you are doing this kind of analysis, perhaps directly modifying
>> kernel source is the way to go ...?
>
> That's what I've been doing for now, but I have a few engineers who need
> to do this sort of testing and aren't kernel developers. I could
> continue to maintain my own patch for this, but I just thought I'd see
> what others thought.
>
> Is there a good reason this can't be in mainline? These features are
> hidden behind a Kconfig symbol called PM_DEBUG anyway, and I think this
> classifies as a pretty simple extension to the limited existing PM
> debugging options.
>

We're currently carrying a similar patch in the chrome os kernel tree.
I would also like to see this go into mainline.

-Chirantan

> Regards,
> Brian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
