Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab3LWGCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 01:02:31 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:54814 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3LWGC2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 01:02:28 -0500
MIME-Version: 1.0
In-Reply-To: <871u14i00j.fsf@nemi.mork.no>
References: <610b63b7594e5cd364c498f60e69b9e174db9257.1387554926.git.viresh.kumar@linaro.org>
	<1651441.C2UQleWVoy@vostro.rjw.lan>
	<871u14i00j.fsf@nemi.mork.no>
Date: Mon, 23 Dec 2013 11:32:28 +0530
Message-ID: <CAKohpok1dGMPSAehwsVeiyHzxaHupenA4sP5cxCrjVYQMyrVWA@mail.gmail.com>
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

On 23 December 2013 11:25, Bjørn Mork <bjorn@mork.no> wrote:
> I can confirm that it fixes the major regression.  With this branch, the
> cpufreq directory is completely removed after a cancelled userspace
> hibernate (with the acpi-cpufreq problem causing failure).  So it is
> possible to restore cpufreq by manually offlining and onlining non-boot
> cores.  No more leftover sysfs attributes.

Thanks for giving it a try once again :)

> But there is still a minor regression compared to the old (v3.11)
> behaviour: Previously the cpufreq functionality would be automatically
> restored by any completed hibernate or suspend cycle, since it would
> effectively do the CPU offline/online. This automatix fixup won't happen
> with the current pm-cpufreq branch.

I didn't understood it completely, sorry :)

As far as I can see from 3.11 code we simply used to fail with any failure
resulting with a call to ->init() or some other call..

And so cpufreq wouldn't have added any directories at all in that case.
And so I think we still required an offline/online sequence to guarantee
things..
