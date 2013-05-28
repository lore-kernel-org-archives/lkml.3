Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964976Ab3E1SLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:11:52 -0400
Received: from mout.gmx.net ([212.227.15.19]:62037 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964871Ab3E1SLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:11:51 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+zYysoSGqz21xcDSNleaO8pb8sb5ROwoL+KAxQeN
	Fnol4VjGbLYzXo
Message-ID: <51A4F363.2040003@gmx.de>
Date: Tue, 28 May 2013 20:11:47 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130516 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost
 ACPI functionality
References: <5183EC09.9080208@gmx.de> <3715884.H8PIhhjRXL@vostro.rjw.lan> <51911826.907@gmail.com> <519120CC.10403@gmx.de> <51912990.8020206@intel.com> <51913B45.80901@gmx.de> <51913E0A.6060402@gmail.com>
In-Reply-To: <51913E0A.6060402@gmail.com>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 09:24 PM, Dirk Brandewie wrote:
> On 05/13/2013 12:13 PM, Toralf Förster wrote:
>> On 05/13/2013 07:57 PM, Dirk Brandewie wrote:
>>>      cd /sys/fs/cgroup/cpu
>>>      mkdir bonic
>>>      echo 400 > boinc/cpu.shares
>>>      boinc &
>>>      echo $! > boinc/tasks
>>
>> In many places of my scripts for automated testing I use currently the
>> "nice -n" prefix at my ThinkPad to keep a long battery life, quiet fan,
>> cool CPU. The CPU just runs with minimal frequency but will give
>> med/max. power on demand.
>>
>> If the P-State governor will be the replacement the old behaviour -
>>
>> the kernel menu config says "will become the perferred ... (sic!)
>> ...scaling driver for Sandy bridge processors" -
>>
>> is there a nifty user space tool which replaces "nice" and do all cgroup
>> stuff for the user ?
>>
> 
> cgexec from the libcgroup-tools package (fedora name) look like it will
> place
> a process in a group for you.
> 
> https://wiki.archlinux.org/index.php/Cgroups
> 
> Has some useful examples.
> 
> --Dirk
> 

I'm not really convinced about using P-State in favour of ondemand -
with the cpu ondemand governor my freshly booted system with just KDE
started stays here around 39°C - with pstate I do have 53°C.

Even more if I run BOINC the temperature is around 92° even with these
settings :

 tail -v /sys/fs/cgroup/cpu/groupname/boinc/*
==> /sys/fs/cgroup/cpu/groupname/boinc/cgroup.clone_children <==
0

==> /sys/fs/cgroup/cpu/groupname/boinc/cgroup.event_control <==
tail: error reading
‘/sys/fs/cgroup/cpu/groupname/boinc/cgroup.event_control’: Invalid argument

==> /sys/fs/cgroup/cpu/groupname/boinc/cgroup.procs <==
3411
3415
3416
3417
3419
3421
3422
3423
3434
3435

==> /sys/fs/cgroup/cpu/groupname/boinc/cpu.cfs_period_us <==
100000

==> /sys/fs/cgroup/cpu/groupname/boinc/cpu.cfs_quota_us <==
-1

==> /sys/fs/cgroup/cpu/groupname/boinc/cpu.shares <==
2

==> /sys/fs/cgroup/cpu/groupname/boinc/cpu.stat <==
nr_periods 0
nr_throttled 0
throttled_time 0

==> /sys/fs/cgroup/cpu/groupname/boinc/notify_on_release <==
0

==> /sys/fs/cgroup/cpu/groupname/boinc/tasks <==
3417
3418
3419
3420
3421
3422
3423
3424
3434
3435


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
