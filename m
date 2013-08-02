Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab3HBHZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 03:25:13 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:56064 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3HBHZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 03:25:10 -0400
MIME-Version: 1.0
In-Reply-To: <51FB5373.9040307@intel.com>
References: <20130731162252.GC4724@pd.tnic>
	<20130731163623.GD4724@pd.tnic>
	<1419236.138PcnXVBh@vostro.rjw.lan>
	<20130801080724.GA3448@nazgul.tnic>
	<51FB4B0A.7060706@intel.com>
	<CAPBO7TaPxa_13FBDE5Z=Aoa+ePPfLRH0+oWSQyEmO00xSfGqYg@mail.gmail.com>
	<51FB5373.9040307@intel.com>
Date: Fri, 2 Aug 2013 09:25:09 +0200
Message-ID: <CAPBO7TZ2nHoF_oZCgSfy0Vs=phqpLT3tWC35kSi9tUQWe3vc9A@mail.gmail.com>
Subject: Re: i915 backlight
From: Josep Lladonosa <jlladono@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Yes, it works! I get now 11 levels from all black to the brightest.

acpi_listen shows messages

Josep

On 2 August 2013 08:36, Aaron Lu <aaron.lu@intel.com> wrote:
> On 08/02/2013 02:25 PM, Josep Lladonosa wrote:
>> Hello,
>>
>> I am using a Lenovo Edge E530 and, with kernel 3.11.0-rc3, I had to
>> change to this parameter to the kernel boot:
>>
>>
>> GRUB_CMDLINE_LINUX="acpi_osi=\"!Windows 2012\""
>
> What if you remove the above from kernel command line, and add
> video.brightness_switch_enabled=0 to kernel command line, then set the
> following in xorg.conf:
> $ cat /etc/X11/xorg.conf
> Section "Device"
>         Option     "Backlight"  "intel_backlight"
>         Identifier  "Card0"
>         Driver      "intel"
>         BusID       "PCI:0:2:0"
> EndSection
>
> Does everything work?
>
> If not, please test if manually change brightness level through sysfs
> works:
> # cd /sys/calss/backlight/intel_backlight
> # echo xxx > brightness
>
> And also test if hotkey event is sent out or not by running acpi_listen
> and then press the hotkey.
>
> Thanks,
> Aaron
>
>>
>>
>> instead of previous
>>
>> GRUB_CMDLINE_LINUX="acpi_osi=Linux acpi_backlight=vendor"
>>
>> to be able to change brightness. In some kernel versions before, it
>> worked, but with 15 levels, but in graphical system brightness bar was
>> not moving.
>>
>>
>> Now I have, though, 8 possible values for brightness and brightness
>> bar shows its correct position.
>>
>> Josep
>>
>> On 2 August 2013 08:00, Aaron Lu <aaron.lu@intel.com> wrote:
>>> On 08/01/2013 04:07 PM, Borislav Petkov wrote:
>>>> On Wed, Jul 31, 2013 at 11:16:52PM +0200, Rafael J. Wysocki wrote:
>>>>> Does reverting efaa14c help?
>>>>
>>>> Nope.
>>>>
>>>> But see my other reply to Aaron.
>>>
>>> Assume you have specified to use intel_backlight in xorg.conf, does
>>> booting with video.brightness_switch_enabled=0 help?
>>>
>>> Thanks,
>>> Aaron
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
>>
>



-- 
--
Salutacions...Josep
--
