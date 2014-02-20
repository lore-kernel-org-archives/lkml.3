Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaBTVgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:36:33 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32777 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaBTVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:36:31 -0500
Message-ID: <5306755B.9050006@gmail.com>
Date: Thu, 20 Feb 2014 13:36:27 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Otto Meier <gf435@gmx.net>, Borislav Petkov <bp@alien8.de>
CC: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [3.14-rc3] possible regression Haswell runs only at 770Mhz with
 powersave governor
References: <53061204.7080700@gmx.net> <20140220150101.GA9557@pd.tnic> <530631E5.5050104@gmail.com> <53065247.9080803@gmx.net>
In-Reply-To: <53065247.9080803@gmx.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 11:06 AM, Otto Meier wrote:
> Am 20.02.2014 17:48, schrieb Dirk Brandewie:
>> On 02/20/2014 07:01 AM, Borislav Petkov wrote:
>>> Add lists to CC.
>>>
>>> On Thu, Feb 20, 2014 at 03:32:36PM +0100, Otto Meier wrote:
>>>> Hello,
>>>>
>>>> My System which runs with older kernels up to 3.13.3
>>>> fine on my i3-4330 with 3.5 Ghz and governor powersave.
>>>> and pstate driver.
>>>>
>>>> With kernel 3.14-rc3 and Governor powersave it runs
>>>> only at 770Mhz and never switches to higher Freq. on load.
>>>> Even compiling a kernel with make -j4   does not change freq.
>>>>
>>
>> commit fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4 seems to be the culprit
>>
>>>> With governor performance  it switches to 3.5 Ghz and stays
>>>> there.
>>>>
>>>> Any Idea how to fix this?
>>>>
>>
>> Greg KH is seeing the same thing on his Haswell system.  I am trying
>> to figure what went south.
>>
>> https://lkml.org/lkml/2014/2/19/626
>>
>>
>> Can you send me the .config for the broken kernel also the output of
>> gcc -v
>>
>>
>>
>>>> Best regards
>>>
>>
>>
>>
>
> Hello
>
> I reverted the mentioned commit.
>
> it now seams to work. But total idle power comsumption is aprox. 5 Watts
> higher as
> running kernel 3.13.3. Measured with a true rms powermeter on primery side.
>

This is the bug the commit was trying to fix :-)  It works well on the test
systems I have,  I am building up a Haswell test system to add to my stable.

Could you send me your whole .config file?

--Dirk
>
> gcc -v:
>
> Using built-in specs.
> COLLECT_GCC=gcc
> COLLECT_LTO_WRAPPER=/usr/lib64/gcc/x86_64-suse-linux/4.8/lto-wrapper
> Target: x86_64-suse-linux
> Configured with: ../configure --prefix=/usr --infodir=/usr/share/info
> --mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64
> --enable-languages=c,c++,objc,fortran,obj-c++,java,ada
> --enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.8
> --enable-ssp --disable-libssp --disable-plugin
> --with-bugurl=http://bugs.opensuse.org/ --with-pkgversion='SUSE Linux'
> --disable-libgcj --disable-libmudflap --with-slibdir=/lib64
> --with-system-zlib --enable-__cxa_atexit
> --enable-libstdcxx-allocator=new --disable-libstdcxx-pch
> --enable-version-specific-runtime-libs --enable-linker-build-id
> --program-suffix=-4.8 --enable-linux-futex --without-system-libunwind
> --with-arch-32=i586 --with-tune=generic --build=x86_64-suse-linux
> Thread model: posix
> gcc version 4.8.1 20130909 [gcc-4_8-branch revision 202388] (SUSE Linux)
>
> .config:
>
> #
> # Power management and ACPI options
> #
> CONFIG_ARCH_HIBERNATION_HEADER=y
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> CONFIG_HIBERNATE_CALLBACKS=y
> CONFIG_HIBERNATION=y
> CONFIG_PM_STD_PARTITION=""
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> CONFIG_PM_AUTOSLEEP=y
> CONFIG_PM_WAKELOCKS=y
> CONFIG_PM_WAKELOCKS_LIMIT=100
> CONFIG_PM_WAKELOCKS_GC=y
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> CONFIG_PM_DEBUG=y
> CONFIG_PM_ADVANCED_DEBUG=y
> # CONFIG_PM_TEST_SUSPEND is not set
> CONFIG_PM_SLEEP_DEBUG=y
> # CONFIG_DPM_WATCHDOG is not set
> CONFIG_PM_TRACE=y
> CONFIG_PM_TRACE_RTC=y
> CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> CONFIG_ACPI_PROCFS=y
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=m
> CONFIG_ACPI_BATTERY=m
> CONFIG_ACPI_BUTTON=m
> CONFIG_ACPI_VIDEO=m
> CONFIG_ACPI_FAN=y
> CONFIG_ACPI_DOCK=y
> CONFIG_ACPI_PROCESSOR=m
> CONFIG_ACPI_HOTPLUG_CPU=y
> CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
> CONFIG_ACPI_THERMAL=m
> CONFIG_ACPI_NUMA=y
> CONFIG_ACPI_CUSTOM_DSDT_FILE=""
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_INITRD_TABLE_OVERRIDE=y
> CONFIG_ACPI_DEBUG=y
> CONFIG_ACPI_PCI_SLOT=y
> CONFIG_X86_PM_TIMER=y
> CONFIG_ACPI_CONTAINER=y
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> CONFIG_ACPI_BGRT=y
> CONFIG_ACPI_APEI=y
> # CONFIG_ACPI_APEI_GHES is not set
> CONFIG_ACPI_APEI_PCIEAER=y
> # CONFIG_ACPI_APEI_MEMORY_FAILURE is not set
> # CONFIG_ACPI_APEI_EINJ is not set
> # CONFIG_ACPI_APEI_ERST_DEBUG is not set
> # CONFIG_ACPI_EXTLOG is not set
> CONFIG_SFI=y
>
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> CONFIG_CPU_FREQ_STAT=m
> CONFIG_CPU_FREQ_STAT_DETAILS=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=m
> CONFIG_CPU_FREQ_GOV_USERSPACE=m
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m
>
> bye
>
>

