Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbaDQLLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:11:33 -0400
Received: from plane.gmane.org ([80.91.229.3]:60652 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbaDQLLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:11:32 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>
Subject: Media keys cause "ACPI: \_SB_.ATKD: Unsupported event" on ASUS laptop
Date: Thu, 17 Apr 2014 14:11:15 +0300
Message-ID: <liocsk$le0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sky.nullroute.eu.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
X-Enigmail-Version: 1.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 1a699476e258 [two months ago], Linux has stopped
recognizing the media & function keys on my laptop's keyboard (the
laptop is ASUS K52JT.206).

When I press any of the Fn keys (Play/Pause, Stop, Prev, Next, Vol+,
Vol-, Mute, WiFi, Brightness +/-...), I get the following messages in dmesg:

| ACPI: \_SB_.ATKD: Unsupported event type 0x45
| ACPI: \_SB_.ATKD: Unsupported event type 0x43
| ACPI: \_SB_.ATKD: Unsupported event type 0x40
| etc.

In the past (v3.14 and earlier), those used to be reported as ACPI and
input events. From `acpi_listen` on a good kernel:

| hotkey ATK0100:00 00000045 00000000
| cd/play CDPLAY 00000080 00000000 K
|
| hotkey ATK0100:00 00000031 0000000d
| button/volumedown VOLDN 00000080 00000000 K
|
| hotkey ATK0100:00 00000016 00000000
|
| hotkey ATK0100:00 00000025 00000001

Bisect output:

1a699476e25814343766342672c655fb135224cc is the first bad commit
commit 1a699476e25814343766342672c655fb135224cc
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu Feb 6 13:58:13 2014 +0100

    ACPI / hotplug / PCI: Hotplug notifications from acpi_bus_notify()

    Since acpi_bus_notify() is executed on all notifications for all
    devices anyway, make it execute acpi_device_hotplug() for all
    hotplug events instead of installing notify handlers pointing to
    the same function for all hotplug devices.
    [...]

* Linux 3.14.0-rc1-00023-g1a699476e258 (bad)
* Linux 3.14.0-rc1-00022-g5e6f236c2631 (good)

(I'm not quite sure why they show up as 3.14-rc1 if they're after 3.14?)

The kernel config is close to that of stock Arch Linux, except with
entirely irrelevant devices disabled (PATA, SCSI, tuner, etc.)

-- 
Mantas Mikulėnas <grawity@gmail.com>

