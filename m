Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaBLHnP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 02:43:15 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39541 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaBLHnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 02:43:13 -0500
Message-ID: <52FB264D.30809@gmail.com>
Date: Wed, 12 Feb 2014 08:44:13 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Peter Wu <lekensteyn@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
CC: Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend
 to RAM
References: <52F2CC7B.80406@gmail.com> <20140211104237.GE18029@intel.com> <8701691.z6Q6jDD18v@al> <1835578.EmLUpvTMQe@vostro.rjw.lan>
In-Reply-To: <1835578.EmLUpvTMQe@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2014 12:58 AM, Rafael J. Wysocki wrote:
> On Tuesday, February 11, 2014 07:17:37 PM Peter Wu wrote:
>> On Tuesday 11 February 2014 12:42:37 Mika Westerberg wrote:
>>> On Mon, Feb 10, 2014 at 11:39:29PM +0100, Rafael J. Wysocki wrote:
>>>>> _STA() returns 0x0A instead of 0x0F. Could there be something missing in
>>>>> the ACPI hotplug code that overlooks this and removes the device on
>>>>> resume?
>>>>
>>>> That is possible.  Actually even quite likely, but let's wait for the
>>>> response from Peter.
>>>
>>> Here's a hack that should take the 0xa return value into consideration. It
>>> turned out that this case is even mentioned in the ACPI spec.
>>
>> Tested-by: Peter Wu <lekensteyn@gmail.com>
>>
>> This works, the devices are not lost anymore after resume. dmesg
>> mentions the 04:00.* devices at resume compared to the unpatched kernel:
>>
>> [   42.650721] PM: Finishing wakeup.
>> [   42.650768] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP03
>> [   42.650772] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP03
>> [   42.650874] iwlwifi 0000:05:00.0: no hotplug settings from platform
>> [   42.650722] Restarting tasks ... done.
>> [   42.650985] video LNXVIDEO:00: Restoring backlight state
>> [   42.650988] video LNXVIDEO:01: Restoring backlight state
>> [   43.124208] ACPI: \_SB_.AC__: ACPI_NOTIFY_BUS_CHECK event: unsupported
>> [   43.128401] jme 0000:04:00.5: irq 50 for MSI/MSI-X
>> [   43.153005] jme 0000:04:00.5 eth0: Link is down
>> [   43.153030] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
>> [   43.154364] iwlwifi 0000:05:00.0: L1 Enabled; Disabling L0S
>> [   43.162307] iwlwifi 0000:05:00.0: Radio type=0x1-0x3-0x1
>> [   43.276220] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP01
>> [   43.276223] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP01
>> [   43.276257] xhci_hcd 0000:02:00.0: no hotplug settings from platform
>> [   43.276267] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP02
>> [   43.276268] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP02
>> [   43.276355] sdhci-pci 0000:04:00.0: no hotplug settings from platform
>> [   43.276368] pci 0000:04:00.2: no hotplug settings from platform
>> [   43.276381] jmb38x_ms 0000:04:00.3: no hotplug settings from platform
>> [   43.276393] jme 0000:04:00.5: no hotplug settings from platform
>> [   43.276398] acpiphp_glue: hotplug_event: Bus check notify on \_SB_.PCI0.RP03
>> [   43.276399] acpiphp_glue: hotplug_event: re-enumerating slots under \_SB_.PCI0.RP03
>> [   43.276491] iwlwifi 0000:05:00.0: no hotplug settings from platform
>> [   43.277214] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>
>> Rafael, do you want me to test the other patch as well?
> 
> No, thanks!
> 
> Mika, I'll add a changelog to your patch and queue it up as a fix for 3.14.
> 

Thanks guys for solving this issue !

Rafael, could this be submitted to stable trees (at least 3.12, 3.13) as
well ?

