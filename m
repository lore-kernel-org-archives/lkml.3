Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaAFG1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:27:21 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:61801 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaAFG1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:27:20 -0500
MIME-Version: 1.0
In-Reply-To: <87wqihmg9a.fsf@nemi.mork.no>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
	<5562479.pVWRuDL0y6@vostro.rjw.lan>
	<87zjne7f75.fsf@nemi.mork.no>
	<2302938.b8tymqrMEz@vostro.rjw.lan>
	<878uuxquxu.fsf@nemi.mork.no>
	<871u0po0gx.fsf@nemi.mork.no>
	<CAKohpo=9p8ArfWyyWkdQm_BWtyWbWe_dsg6VAUP60VUFcAjFSw@mail.gmail.com>
	<87wqihmg9a.fsf@nemi.mork.no>
Date: Mon, 6 Jan 2014 11:57:19 +0530
Message-ID: <CAKohpo=3s6=gw8OJTrUdLH8o2ouA=8a8MhrgNRXwHmOf0si5Pw@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
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

On 3 January 2014 17:25, Bjørn Mork <bjorn@mork.no> wrote:
> Correct. And users not running a lock debugging kernel will of course
> not even see the warning.

Okay..

>> - It only happens when cpufreq_add_dev() fails during hibernation while
>> we enable non-boot CPUs again to save image to disk. So, isn't a problem
>> for a system which doesn't have any issues with add_dev() failing on
>> hibernation
>
> Wrong.  This was my initial assumption but I later found out that the
> issue is unrelated to hibernation failures.  Sorry about the confusion.

Hmm.. Can we have the latest warning logs you have? Earlier ones were
related to hibernation..

>> - There is a contention of locks in the order they are taken. And the contention
>> looks to be between, hotplug lock taken by cpu_online_cpus() and s_active
>> lock for sysfs files. Don't know what's the role of previous write to
>> sysfs files.
>> As that should finish before hibernation starts and so all locks should be back
>> in place.
>
> Yes, that seems logical.  But I guess this is where it fails?

It looked like that.. Though your new logs might indicate something else.
