Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195Ab3LWLN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 06:13:28 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:58951 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab3LWLN1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 06:13:27 -0500
MIME-Version: 1.0
In-Reply-To: <87txdzx2bb.fsf@nemi.mork.no>
References: <610b63b7594e5cd364c498f60e69b9e174db9257.1387554926.git.viresh.kumar@linaro.org>
	<1651441.C2UQleWVoy@vostro.rjw.lan>
	<871u14i00j.fsf@nemi.mork.no>
	<CAKohpok1dGMPSAehwsVeiyHzxaHupenA4sP5cxCrjVYQMyrVWA@mail.gmail.com>
	<87d2kokqdl.fsf@nemi.mork.no>
	<52B7EC81.6060202@linaro.org>
	<877gavgbuv.fsf@nemi.mork.no>
	<CAKohpo=0HRihdTiQLk+mKiarUdXOPO3n7GCJ9CUoi=4xJ_AYcg@mail.gmail.com>
	<87txdzx2bb.fsf@nemi.mork.no>
Date: Mon, 23 Dec 2013 16:43:26 +0530
Message-ID: <CAKohpon7nn5cpJVNZzzXxbYUkACEsFgyPR20kSSMMsShw0=HVA@mail.gmail.com>
Subject: Re: [PATCH Resend] cpufreq: remove sysfs files for CPU which failed
 to come back after resume
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 December 2013 16:27, Bjørn Mork <bjorn@mork.no> wrote:
> I could be missing something, but I haven't noticed any attempt to
> preserve anything except the sysfs files.

What do you mean by sysfs here? Doesn't the below files mentioned
by you also come in sysfs?

> I tried modifying the max frequency, using
>
>  echo 800000 >/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
>  echo 800000 >/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq
>
> After supend + resume the boot CPU still had the modifed maximum, while
> the non-boot core was reset to the default value.

This is all we were doing. i.e. not removing or putting the kobject which has
all these files and so shouldn't get reallocated at all..

So, has resumed passed on the first go only? As it was failing for the first
time in your case and hence this thread. In that case we are going to get
new files and so all values will be restored to default values.

Otherwise I don't see why we should loose any values here..

>  I changed the gid of
> both files too, verifying that they were saved and restored as expected.
> But the value will change to default.

For both boot and non-boot CPUs? I am asking because things should
be very plain for boot CPU atleast as that is never hot unplugged..

Have you tested this with the latest patches I gave?

> IMHO it would still be a lot better if this was handled as a true
> hotplug event, allowing userspace to reset values/modes/owners on
> resume. Hiding the hotplug event and saving part of the userspace
> controlled environment is worse than not doing anything at all.

We should be saving everything correctly with the current code,
with the patches I have sent.. And so things should work as far
as I can comment.

If you can confirm that these happened despite of latest patches
then probably I need to test that again on my thinkpad. But I was
quite sure this worked :)
