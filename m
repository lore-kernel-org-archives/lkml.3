Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3KPPRe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 10:17:34 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:40940 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3KPPRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 10:17:24 -0500
MIME-Version: 1.0
In-Reply-To: <2235672.LLJc6e6dny@vostro.rjw.lan>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org>
	<5020664.HldDXMO8cr@vostro.rjw.lan>
	<5286F536.70403@linaro.org>
	<2235672.LLJc6e6dny@vostro.rjw.lan>
Date: Sat, 16 Nov 2013 20:47:24 +0530
Message-ID: <CAKohpok_zjdRVz5-ZGRmZtwysC7jORm2mgRbLWDUzo1ucYVKZg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 November 2013 19:59, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:

> Well, disabling it for the whole duration of suspend/resume and/or hibernation
> may not be the right approach entirely, unless we force the pax perf of the

s/pax/max ?

> boot CPU at least in addition to that.  Otherwise the latency of suspend and
> the subsequent resume will depend on what perf level the CPUs where before
> disabling the governors, which is not desirable at al.

Well that is pretty much doable.

>> And these are the notifications that we send:
>> - PM_HIBERNATION_PREPARE
>> - PM_POST_HIBERNATION
>> - PM_RESTORE_PREPARE
>> - PM_POST_RESTORE
>>
>> If I am not wrong I need to stop governors on PM_HIBERNATION_PREPARE and need to
>> start them back on: PM_POST_HIBERNATION (I am a bit confused with this one. Does
>> this POST_HIBERNATION one happens at the end of going into hibernation? or after
>> booting back? I need a notifier at the end of restore)..
>
> You'd need both PM_POST_HIBERNATION and PM_POST_RESTORE, but I wouldn't really
> like cpufreq governors to be disabled throughout the whole hibernation.

So PM_POST_HIBERNATION is called just before shutting off the system? And
PM_POST_RESTORE is called after system is resumed from saved image?

> Actually, we use CPU offline/online during system suspend/resume to avoid
> having to do stuff like this from PM notifiers.

I didn't get the logic behind this one..

> So I'd like the original problem to be addressed in a different way.

Hmm..

> PS
> The sisk.pl address will start bouncing shortly, so please replace it with
> rjw@rjwysocki.net in your address book.

Okay...
