Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaGKNNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:13:04 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:52019 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaGKNNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:13:02 -0400
MIME-Version: 1.0
In-Reply-To: <1405026844.2613.15.camel@fedora-lan>
References: <1405017900-16024-1-git-send-email-benjamin.tissoires@redhat.com>
	<1405026844.2613.15.camel@fedora-lan>
Date: Fri, 11 Jul 2014 09:13:00 -0400
Message-ID: <CAN+gG=Ev+ZuEkLFRxvDT2qRnjfcnAxKCzCjazimVKjRxZ2N7-g@mail.gmail.com>
Subject: Re: [PATCH 0/5] Input - wacom: battery enhancements and unifying
 hid-wacom and wacom
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Przemo,

On Thu, Jul 10, 2014 at 5:14 PM, Przemo Firszt <przemo@firszt.eu> wrote:
> Dnia 2014-07-10, czw o godzinie 14:44 -0400, Benjamin Tissoires pisze:
> [..]
> Hi Benjamin,
>> However, I did not backport the speed attribute and the ac power
>> device (which
>> is infered by the battery status). I don't know if there are users of
>> those two,
>> so I let them aside for now. Przemo, any ideas if this is actually
>> used?
> Both tablets that I had (Graphire Wireless and Intuos4 Wireless)
> supports slow and fast reporting. Slow reporting is necessary with older
> bluetooth receivers otherwise the lag between pen movement and cursor
> movement made devices unusable.

Alright

>
> I tried to expose all events reported by hardware and I think AC
> reporting should stay in the kernel.

Ok, I'll send a v2 next week with these two things fixed.

Cheers,
Benjamin

>
> Intuos4 Wireless
> AC power disconnected:
> bash-4.2$ cat /sys/class/power_supply/wacom_ac/uevent
> POWER_SUPPLY_NAME=wacom_ac
> POWER_SUPPLY_PRESENT=0
> POWER_SUPPLY_ONLINE=0
> POWER_SUPPLY_SCOPE=Device
> bash-4.2$ cat /sys/class/power_supply/wacom_battery/uevent
> POWER_SUPPLY_NAME=wacom_battery
> POWER_SUPPLY_PRESENT=1
> POWER_SUPPLY_CAPACITY=85
> POWER_SUPPLY_SCOPE=Device
> POWER_SUPPLY_STATUS=Discharging
>
> AC power connected:
> bash-4.2$ cat /sys/class/power_supply/wacom_ac/uevent
> POWER_SUPPLY_NAME=wacom_ac
> POWER_SUPPLY_PRESENT=1
> POWER_SUPPLY_ONLINE=1
> POWER_SUPPLY_SCOPE=Device
> bash-4.2$ cat /sys/class/power_supply/wacom_battery/uevent
> POWER_SUPPLY_NAME=wacom_battery
> POWER_SUPPLY_PRESENT=1
> POWER_SUPPLY_CAPACITY=85
> POWER_SUPPLY_SCOPE=Device
> POWER_SUPPLY_STATUS=Charging
> --
> Kind regards,
> Przemo Firszt
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
