Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128Ab3LWG4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 01:56:07 -0500
Received: from canardo.mork.no ([148.122.252.1]:52370 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab3LWG4F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 01:56:05 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq\@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH Resend] cpufreq: remove sysfs files for CPU which failed to come back after resume
Organization: m
References: <610b63b7594e5cd364c498f60e69b9e174db9257.1387554926.git.viresh.kumar@linaro.org>
	<1651441.C2UQleWVoy@vostro.rjw.lan> <871u14i00j.fsf@nemi.mork.no>
	<CAKohpok1dGMPSAehwsVeiyHzxaHupenA4sP5cxCrjVYQMyrVWA@mail.gmail.com>
Date: Mon, 23 Dec 2013 07:55:50 +0100
In-Reply-To: <CAKohpok1dGMPSAehwsVeiyHzxaHupenA4sP5cxCrjVYQMyrVWA@mail.gmail.com>
	(Viresh Kumar's message of "Mon, 23 Dec 2013 11:32:28 +0530")
Message-ID: <87d2kokqdl.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:
> On 23 December 2013 11:25, Bjørn Mork <bjorn@mork.no> wrote:
>> I can confirm that it fixes the major regression.  With this branch, the
>> cpufreq directory is completely removed after a cancelled userspace
>> hibernate (with the acpi-cpufreq problem causing failure).  So it is
>> possible to restore cpufreq by manually offlining and onlining non-boot
>> cores.  No more leftover sysfs attributes.
>
> Thanks for giving it a try once again :)
>
>> But there is still a minor regression compared to the old (v3.11)
>> behaviour: Previously the cpufreq functionality would be automatically
>> restored by any completed hibernate or suspend cycle, since it would
>> effectively do the CPU offline/online. This automatix fixup won't happen
>> with the current pm-cpufreq branch.
>
> I didn't understood it completely, sorry :)
>
> As far as I can see from 3.11 code we simply used to fail with any failure
> resulting with a call to ->init() or some other call..
>
> And so cpufreq wouldn't have added any directories at all in that case.
> And so I think we still required an offline/online sequence to guarantee
> things..

That's correct.  The immediate result of the failure is exactly the
same.

The difference is that a subsequent resume would restore the cpufreq
device whether it existed or not.  That made a complete suspend/resume
fix up any missing cpufreq device, e.g. one that was removed by a
previous error.

One effect of saving state on suspend is that a missing device isn't
added on resume.  You can of course see that as a feature.  But to me
it's a regression, because:
 - it didn't use to work that way, and
 - the addition of missing devices on resume is always wanted AFAICS.


Bjørn
