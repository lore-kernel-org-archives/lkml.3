Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3BEI20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 03:28:26 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46507 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab3BEI2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 03:28:22 -0500
MIME-Version: 1.0
In-Reply-To: <2765418.Ft0GYkgNgL@vostro.rjw.lan>
References: <1360017913-25667-1-git-send-email-nzimmer@sgi.com>
	<2765418.Ft0GYkgNgL@vostro.rjw.lan>
Date: Tue, 5 Feb 2013 13:58:20 +0530
X-Google-Sender-Auth: tmI8P707eb6lPKixgqt4Fs_056Q
Message-ID: <CAOh2x=n+ASeLpGHexxDvPGrN6ia+bLnNUNCb-covGDoABVk_wQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] cpufreq: cpufreq_driver_lock is hot on large systems
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 6:37 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, February 04, 2013 04:45:11 PM Nathan Zimmer wrote:
>> I am noticing the cpufreq_driver_lock is quite hot.
>> On an idle 512 system perf shows me most of the system time is spent on this
>> lock.  This is quite signifigant as top shows 5% of time in system time.
>> My solution was to first convert the lock to a rwlock and then to the rcu.
>>
>>
>> Nathan Zimmer (2):
>>   cpufreq: Convert the cpufreq_driver_lock to a rwlock
>>   cpufreq: Convert the cpufreq_driver_lock to use the rcu
>>
>>  drivers/cpufreq/cpufreq.c | 139 ++++++++++++++++++++++++++--------------------
>>  1 file changed, 79 insertions(+), 60 deletions(-)
>
> I like these changes.
>
> Viresh, anyone, any comments?

Hi Nathan/Rafael,

Even i liked the basic idea behind the patchset, but didn't like the way it
is divided into patches. For me, it is highly discouraged to undo something
that you added in the same patchset. And you did exactly the same thing.

Patch 2 is revert of 1 + rcu stuff.

So, i would expect a single patch, i.e. merge of both patches + rebased
on latest stuff.

--
viresh
