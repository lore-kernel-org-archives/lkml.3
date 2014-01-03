Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaACLzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:55:42 -0500
Received: from canardo.mork.no ([148.122.252.1]:34296 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbaACLzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:55:38 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq\@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
Organization: m
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
	<5562479.pVWRuDL0y6@vostro.rjw.lan> <87zjne7f75.fsf@nemi.mork.no>
	<2302938.b8tymqrMEz@vostro.rjw.lan> <878uuxquxu.fsf@nemi.mork.no>
	<871u0po0gx.fsf@nemi.mork.no>
	<CAKohpo=9p8ArfWyyWkdQm_BWtyWbWe_dsg6VAUP60VUFcAjFSw@mail.gmail.com>
Date: Fri, 03 Jan 2014 12:55:29 +0100
In-Reply-To: <CAKohpo=9p8ArfWyyWkdQm_BWtyWbWe_dsg6VAUP60VUFcAjFSw@mail.gmail.com>
	(Viresh Kumar's message of "Fri, 3 Jan 2014 16:49:17 +0530")
Message-ID: <87wqihmg9a.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Viresh Kumar <viresh.kumar@linaro.org> writes:

> On 3 January 2014 15:23, Bjørn Mork <bjorn@mork.no> wrote:
>> Note that "ondemand" and "1401000" are the default vaules, so I don't
>> actually change anything here.  The write is causing the problem, not
>> the value.  As expected, I guess.
>>
>> Also note that boot vs non-boot cpu doesn't seem to matter.  Nor does
>> cancelling the hibernation.  The warning appears on hibernate - not on
>> resume.
>
> Hmm... I spent quite some time understanding whats going on and really
> couldn't get across anything as of now. I haven't tried reproducing it though.
>
> Few things that I can make out of this mail chain so far:
> - Apart from the log, everything is working fine. i.e. system is back in
> working condition.

Correct. And users not running a lock debugging kernel will of course
not even see the warning.

> - It only happens when cpufreq_add_dev() fails during hibernation while
> we enable non-boot CPUs again to save image to disk. So, isn't a problem
> for a system which doesn't have any issues with add_dev() failing on
> hibernation

Wrong.  This was my initial assumption but I later found out that the
issue is unrelated to hibernation failures.  Sorry about the confusion.

> - There is a contention of locks in the order they are taken. And the contention
> looks to be between, hotplug lock taken by cpu_online_cpus() and s_active
> lock for sysfs files. Don't know what's the role of previous write to
> sysfs files.
> As that should finish before hibernation starts and so all locks should be back
> in place.

Yes, that seems logical.  But I guess this is where it fails?



Bjørn
