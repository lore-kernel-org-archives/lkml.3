Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaLSNxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 08:53:31 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34629 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaLSNx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 08:53:27 -0500
Message-ID: <54942DC9.9070306@linaro.org>
Date: Fri, 19 Dec 2014 21:53:13 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Timur Tabi <timur@codeaurora.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jon Masters <jcm@redhat.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        Kangkang.Shen@huawei.com, linux-acpi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, linaro-acpi@lists.linaro.org,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org>	<1413553034-20956-19-git-send-email-hanjun.guo@linaro.org> <CAOZdJXWaQk+f6MLngDzdmUU8x=4cPrt9kpJG6L529MhV0uQwdA@mail.gmail.com>
In-Reply-To: <CAOZdJXWaQk+f6MLngDzdmUU8x=4cPrt9kpJG6L529MhV0uQwdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Timur,

On 2014年12月19日 04:04, Timur Tabi wrote:
> On Fri, Oct 17, 2014 at 8:37 AM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>
>> If acpi=force is used, the kernel
>> +will ONLY use device configuration information contained in the ACPI tables.
>
> Based on this statement, ...
>
>> +In order for the kernel to load and use ACPI tables, the UEFI implementation
>> +MUST set the ACPI_20_TABLE_GUID to point to the RSDP table (the table with
>> +the ACPI signature "RSD PTR ").  If this pointer is incorrect and acpi=force
>> +is used, the kernel will disable ACPI and try to use DT to boot.
>
> wouldn't it be more correct to say "If this pointer is incorrect OR
> acpi=force is used"?

Good catch, some inconsistency here. Actually it means if the pointer to
RSDP is incorrect, the ACPI code will catch that error, then ACPI will
be disabled and tries to boot with DT even if acpi=force is passed, I
think that makes sense.

I will fix the inconsistency anyway in next version.

>
>> +Forum provides a mechanism for registering such bindings [URL TBD by ASWG]
>
> Did you intend to replace the text in []?

Yes, it is TBD by ASWG, and we already agreed that the bindings will be
reviewed by ASWG which proposed by Al. the URL will be ready when next
version of ACPI spec is released.

>
>> +so that they may be used on any operating system supporting ACPI.  Device
>> +properties that have not been registered with the UEFI Forum should not be
>> +used.
>
> Blech.  I guess it's necessary, but the information needs to be documented here.
>
>> +Drivers should look for device properties in the _DSD object ONLY; the _DSD
>> +object is described in the ACPI specification section 6.2.5, but more
>> +specifically, use the _DSD Device Properties UUID:
>> +
>> +   -- UUID: daffd814-6eba-4d8c-8a91-bc9bbf4aa301
>> +
>> +   -- http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf)
>
> Extra ) here.

Good catch :)

>
>> +The kernel has an interface for looking up device properties in a manner
>> +independent of whether DT or ACPI is being used and that interface should
>> +be used; it can eliminate some duplication of code paths in driver probing
>> +functions and discourage divergence between DT bindings and ACPI device
>> +properties.
>
> How about a pointer to the documentation for this method?

This is a patch set posted by Rafael and goes into 3.19:
https://lkml.org/lkml/2014/10/21/762

No documentation as far as I know.

>
>> +Such code in _PS? methods will of course be very platform specific.  But,
>
> I would use _PSx instead of _PS? here.

I will update it.

>
>> +this allows the driver to abstract out the interface for operating the device
>> +and avoid having to read special non-standard values from ACPI tables. Further,
>> +abstracting the use of these resources allows the hardware to change over time
>> +without requiring updates to the driver.
>> +
>> +
>> +Clocks
>> +------
>> +ACPI makes the assumption that clocks are initialized by the firmware --
>> +UEFI, in this case -- to some working value before control is handed over
>> +to the kernel.  This has implications for devices such as UARTs, or SoC
>> +driven LCD displays, for example.
>
> SOC-driven should be hyphenated.
>
>> +When the kernel boots, the clock is assumed to be set to reasonable
>
> to A reasonable
>
>> +working value.  If for some reason the frequency needs to change -- e.g.,
>> +throttling for power management -- the device driver should expect that
>> +process to be abstracted out into some ACPI method that can be invoked
>> +(please see the ACPI specification for further recommendations on standard
>> +methods to be expected).  If is not, there is no direct way for ACPI to
>
> If IT is not
>
>> +control the clocks.
>> +
>> +
>> +Driver Recommendations
>> +----------------------
>> +DO NOT remove any DT handling when adding ACPI support for a driver.  The
>> +same device may be used on many different systems.
>> +
>> +DO try to structure the driver so that it is data driven.  That is, set up
>
> data-driven

I will update them.

Thanks a lot for your review!

Hanjun
