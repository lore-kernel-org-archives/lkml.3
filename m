Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3EMR5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:57:41 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:56425 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3EMR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:57:40 -0400
Message-ID: <51912990.8020206@intel.com>
Date: Mon, 13 May 2013 10:57:36 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost
 ACPI functionality
References: <5183EC09.9080208@gmx.de> <3715884.H8PIhhjRXL@vostro.rjw.lan> <51911826.907@gmail.com> <519120CC.10403@gmx.de>
In-Reply-To: <519120CC.10403@gmx.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 10:20 AM, Toralf Förster wrote:
> On 05/13/2013 06:43 PM, Dirk Brandewie wrote:
>> I spent some more time looking for a solution to this you can get same
>> behavior
>> by setting a config option in BOINC  "Use at most X % CPU time"
>
> yes - that's true. But BOINC is just an example.
>
> If "nice -19 <loooong running background job" is nowadays so uncommon,
> then I'm just curious what's the modern (easy) way of doing that ?
>

I believe using CGROUP's is the right answer for limiting this type
of load.

I have not tested it but from reading:
	Documentation/scheduler/sched-design-CFS.txt
	https://wiki.archlinux.org/index.php/Cgroups

You should be able to do something like the following:

	cd /sys/fs/cgroup/cpu
	mkdir bonic
	echo 400 > boinc/cpu.shares
	boinc &
	echo $! > boinc/tasks

Should limit the boinc group to ~40% of the cpu.

WARNING completely untested YMMV

--Dirk
