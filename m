Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaACKPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 05:15:30 -0500
Received: from canardo.mork.no ([148.122.252.1]:33037 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaACKP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 05:15:28 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: cpufreq@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
Organization: m
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
	<5562479.pVWRuDL0y6@vostro.rjw.lan> <87zjne7f75.fsf@nemi.mork.no>
	<2302938.b8tymqrMEz@vostro.rjw.lan> <878uuxquxu.fsf@nemi.mork.no>
Date: Fri, 03 Jan 2014 10:53:34 +0100
In-Reply-To: <878uuxquxu.fsf@nemi.mork.no> (=?utf-8?Q?=22Bj=C3=B8rn?=
 Mork"'s message of "Fri, 03
	Jan 2014 10:24:45 +0100")
Message-ID: <871u0po0gx.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjørn Mork <bjorn@mork.no> writes:
> "Rafael J. Wysocki" <rjw@rjwysocki.net> writes:
>
>> OK, thanks!  Well, this is somewhat worrisome.
>>
>> Could you also check the linux-pm.git/fixes branch that contains all patches
>> I'm planning to push for 3.13-rc7 shortly?
>
> It's definitely still there.  But I'm less sure about the exact trigger.

I did a couple of more tests after clean reboots, and 100% sure ways to
trigger the circular locking on my laptop are

  echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  s2disk

or

  echo 1401000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 
  s2disk

or

  echo 1401000 > /sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq 
  s2disk


Note that "ondemand" and "1401000" are the default vaules, so I don't
actually change anything here.  The write is causing the problem, not
the value.  As expected, I guess.

Also note that boot vs non-boot cpu doesn't seem to matter.  Nor does
cancelling the hibernation.  The warning appears on hibernate - not on
resume.

Hope this helps.


Bjørn
