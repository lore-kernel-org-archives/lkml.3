Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaBYGIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 01:08:17 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:44792 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaBYGIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 01:08:15 -0500
MIME-Version: 1.0
In-Reply-To: <530C2FD7.4000105@linux.vnet.ibm.com>
References: <15ccc0609cb9ee3db0ad3a95b29bf69d11ea197c.1392375504.git.viresh.kumar@linaro.org>
	<CAKohpo=mQWxoKTduR8FrrB4Qz45qXQrJjSudq=FkCJtHBTbo2Q@mail.gmail.com>
	<5301CE86.9020105@linux.vnet.ibm.com>
	<1489022.1IbaesBAQQ@vostro.rjw.lan>
	<CAKohpokGtcJbdzt0FPZnKjSFi54Np+Ss7--Z83UEZp8FMY94pQ@mail.gmail.com>
	<CAKohpokk5-6vGV93fZDob8Q=xZXsd7E4OkMUAC1M6Z71G=d1Ow@mail.gmail.com>
	<530C2FD7.4000105@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 11:38:14 +0530
Message-ID: <CAKohponr5b8nBaV9TFiiFkvyg8Qb6qz_0UXbYCaFRPG=XP28rA@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Return error if ->get() failed in cpufreq_update_policy()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pierre Ossman <pierre-list@ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 February 2014 11:23, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Hmm, that's a good point. However, lets first think about the simple scenario
> that the driver _is_ able to detect the current frequency from the hardware
> (a non-zero, sane value) say X KHz, and that frequency is different from what
> the cpufreq subsystem thinks it is (Y KHz).
>
> In the current code, when we observe this, we send out a notification and try
> to adjust to X KHz. Instead, what I'm suggesting is to invoke the driver to
> set the frequency to Y KHz, since that's what the cpufreq subsystems wants the
> frequency to be at.

Actually we don't know at this point what cpufreq wants :)
Governor will decide what frequency to run CPU at and lets leave it to
that point.
As the transition that we might end up doing here would be simply overridden
very soon. And to be honest this decision must be taken by governor and not
core. We just want to make sure core is in sync with hardware.

> As for the case where the driver reports the frequency to be 0 KHz, we can
> print a WARN() and try to force set the frequency to Y KHz. But if that turns
> out to be too tricky to handle, we can just put a WARN() and error out, as you
> proposed earlier.

Ok..
