Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763751Ab3ECVKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:10:50 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:65168 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763484Ab3ECVKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:10:47 -0400
Message-ID: <518427D4.3050104@gmail.com>
Date: Fri, 03 May 2013 14:10:44 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>, linux-acpi@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: 3.9.0 + CONFIG_X86_INTEL_PSTATE=y  -> ThinkPad T420 with i5 lost
 ACPI functionality
References: <5183EC09.9080208@gmx.de> <3715884.H8PIhhjRXL@vostro.rjw.lan>
In-Reply-To: <3715884.H8PIhhjRXL@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 12:36 PM, Rafael J. Wysocki wrote:
> On Friday, May 03, 2013 06:55:37 PM Toralf Förster wrote:
>> The following file doesn't exists at my Gentoo Linux
>> /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
>> in 3.9.0 if I activate CONFIG_X86_INTEL_PSTATE=y
>>
>> That means, that a command like
>>
>> $> echo 1 > /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load
>>
>> in /etc/rc.local is now no longer working.
>> A high fan +  high temperature are the result, even if just the BOINC client
>> is run with low prio (nice 19) in the back ground.
>>


ignore_nice_load is a feature of the ondemand governor.

The intel_pstate driver is seeing the load presented by the BOINC client and
is adjusting the pstate accordingly.

>> Manually loading the missing module won't work too :
>>
>> $> modprobe acpi_cpufreq
>> modprobe: ERROR: could not insert 'acpi_cpufreq': Device or resource busy
>>
>> Is the behaviour a bug or a feature ?

The intel_pstate drive has already registered as a scaling driver so when
acpi_cpufreq tries to register as a scaling driver the registration fails

>
> The thermal management problem is not an intentional outcome, definitely.
>
>> In the later case: How can I achieve the previous behaviour back ?
>>

If you require the ondemand governor you can remove CONFIG_X86_INTEL_PSTATE
from your configuration or add "intel_pstate=disable" to your kernel command
line.

--Dirk
>> This issue might affect the RH EL kernel too [1] where I observed a similar behaviour.
>>
>>
>> [1] http://elrepo.org/bugs/view.php?id=379
>
> Dirk, is this the problem we were talking about recently or something else?
>
> Rafael
>
>

