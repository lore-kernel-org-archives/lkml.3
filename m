Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250AbaDXFWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 01:22:06 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:44365 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaDXFWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 01:22:04 -0400
Date: Thu, 24 Apr 2014 06:21:52 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] Media keys cause "ACPI: \_SB_.ATKD: Unsupported
 event" on ASUS laptop
Message-ID: <20140424052151.GA9449@sucs.org>
References: <liocsk$le0$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <liocsk$le0$1@ger.gmane.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 02:11:15PM +0300, Mantas Mikulėnas wrote:
> After commit 1a699476e258 [two months ago], Linux has stopped
> recognizing the media & function keys on my laptop's keyboard (the
> laptop is ASUS K52JT.206).
> 
> When I press any of the Fn keys (Play/Pause, Stop, Prev, Next, Vol+,
> Vol-, Mute, WiFi, Brightness +/-...), I get the following messages in dmesg:
> 
> | ACPI: \_SB_.ATKD: Unsupported event type 0x45
> | ACPI: \_SB_.ATKD: Unsupported event type 0x43
> | ACPI: \_SB_.ATKD: Unsupported event type 0x40
> | etc.

I'm seeing the same problem with an EeePC 900's volume and brightness
keys:
[   90.098518] ACPI: \_SB_.ATKD: Unsupported event type 0x14
[   90.785202] ACPI: \_SB_.ATKD: Unsupported event type 0x15
[  457.062072] ACPI: \_SB_.ATKD: Unsupported event type 0x2e
[  457.926754] ACPI: \_SB_.ATKD: Unsupported event type 0x2d
[  458.418740] ACPI: \_SB_.ATKD: Unsupported event type 0x2c
[  458.821482] ACPI: \_SB_.ATKD: Unsupported event type 0x2b
[  459.240896] ACPI: \_SB_.ATKD: Unsupported event type 0x2a


> In the past (v3.14 and earlier), those used to be reported as ACPI and
> input events. From `acpi_listen` on a good kernel:
> 
> | hotkey ATK0100:00 00000045 00000000
> | cd/play CDPLAY 00000080 00000000 K
> |
> | hotkey ATK0100:00 00000031 0000000d
> | button/volumedown VOLDN 00000080 00000000 K
> |
> | hotkey ATK0100:00 00000016 00000000
> |
> | hotkey ATK0100:00 00000025 00000001
> 
> Bisect output:
> 
> 1a699476e25814343766342672c655fb135224cc is the first bad commit
> commit 1a699476e25814343766342672c655fb135224cc
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Thu Feb 6 13:58:13 2014 +0100
> 
>     ACPI / hotplug / PCI: Hotplug notifications from acpi_bus_notify()
> 
>     Since acpi_bus_notify() is executed on all notifications for all
>     devices anyway, make it execute acpi_device_hotplug() for all
>     hotplug events instead of installing notify handlers pointing to
>     the same function for all hotplug devices.
>     [...]
> 
> * Linux 3.14.0-rc1-00023-g1a699476e258 (bad)
> * Linux 3.14.0-rc1-00022-g5e6f236c2631 (good)
> 
> (I'm not quite sure why they show up as 3.14-rc1 if they're after 3.14?)
> 
> The kernel config is close to that of stock Arch Linux, except with
> entirely irrelevant devices disabled (PATA, SCSI, tuner, etc.)

Adding email addresses recommended by get_maintainer.pl to see if that
helps this to get noticed...

-- 
Sitsofe | http://sucs.org/~sits/
