Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab3K0C4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:56:07 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:62215 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758669Ab3K0C4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:56:01 -0500
MIME-Version: 1.0
In-Reply-To: <9179214.Tbesu8t5px@vostro.rjw.lan>
References: <cover.1385118255.git.viresh.kumar@linaro.org>
	<e4bc55fac6bc68694e9905cc3cc6844173b64925.1385118256.git.viresh.kumar@linaro.org>
	<20131126193902.GA2481@amd.pavel.ucw.cz>
	<9179214.Tbesu8t5px@vostro.rjw.lan>
Date: Wed, 27 Nov 2013 08:26:00 +0530
Message-ID: <CAKohpo=4ZdDybsm6oz0-GjCyP2c8MGvV9uZG8n+Cv2xGKcmeDQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] cpufreq: suspend governors on system suspend/hibernate
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
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

On 27 November 2013 01:48, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Tuesday, November 26, 2013 08:39:02 PM Pavel Machek wrote:
>> So... we freeze frequencies in whatever state they are, yes?

Better go through the V3 of this patchset:

https://lkml.org/lkml/2013/11/25/838

We are giving drivers and opportunity to set core to whatever frequency they
want before suspending.

> Yes.  The idea was to do that after suspending devices in which case it wouldn't
> matter so much.  But Viresh always has to complicate things.

:)

Its complicated by the kind of designs we have for our hardware. We tried the
noirq callbacks and it worked atleast for Nishanth, who reported the problem
initially. But the problem started when drivers wanted to change their
frequencies before suspending and that can't happen in noirq place..

I had another idea but then left it thinking that it might be even more
complicated :)

What about both dpm_suspend_noirq and dpm_suspend callbacks. Drivers
will change freq in dpm_suspend_noirq and dpm_suspend will stop governors?

But the question is can governors try another frequency at that time?
i.e. override whatever is configured by drivers?

>> Should we go to some specific frequency?
>
> If that is done where it is done, yes, we should.

You meant dpm_suspend() here, right?
