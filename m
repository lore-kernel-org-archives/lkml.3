Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbaKTL7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:59:09 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:32887 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaKTL7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:59:06 -0500
Message-ID: <546DD783.2030902@collabora.co.uk>
Date: Thu, 20 Nov 2014 12:58:59 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: cros_ec: Create sysfs attributes for the ChromeOS
 EC.
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk> <1416238213-15263-3-git-send-email-javier.martinez@collabora.co.uk> <20141118142645.GD24004@x1>
In-Reply-To: <20141118142645.GD24004@x1>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lee,

On 11/18/2014 03:26 PM, Lee Jones wrote:
> On Mon, 17 Nov 2014, Javier Martinez Canillas wrote:
> 
>> From: Bill Richardson <wfrichar@chromium.org>
>> 
>> This adds the first few sysfs attributes for the Chrome OS EC. These
>> controls are made available under /sys/devices/virtual/chromeos/cros_ec
>> 
>>     flashinfo   - display current flash info
> 
> drivers/mtd?
> 
>>     reboot      - tell the EC to reboot in various ways
> 
> drivers/power?
>

Well this driver is special in the sense that there is a Cortex-M Embedded
Controller that has different peripherals (flash, keyboard, charger, etc).
The kernel communicates with these peripherals by using a tunnel through
the protocol used to communicate with the Embedded Controller (SPI/I2C/LPC).

But you are right that this is not suitable for drivers/mfd, I just added
there because that is the location in the downstream ChromeOS kernel but
like you said, the MFD subsystem should not be a dumping ground for devices
that is not clear where should live.

On v2 I'll add this sysfs interface and the dev to drivers/platform/chrome/
since I think is a better place for the cros_ec dev driver. It will still
be spawns from the cros_ec MFD driver though but that is OK for you AFAIU.
 
>>     version     - information about the EC software and hardware
> 
> What's the difference between this version and the version you can
> read in the new _dev driver?
>

The version information read from the cros_ec dev interface is a subset
of the information read from the version sysfs, e.g:

$ cat /dev/cros_ec
1.0.0
pit_v1.1.1198-1cd618e
pit_v1.1.1198-1cd618e
read-only

$ cat /sys/class/chromeos/cros_ec/version
RO version:    pit_v1.1.1198-1cd618e
RW version:    pit_v1.1.1198-1cd618e
Firmware copy: RO
Build info:    pit_v1.1.1198-1cd618e 2014-04-30 16:29:52 @build122-m2
Chip vendor:   stm
Chip name:     stm32l15x
Chip revision:
Board version: 0

I don't really know why there are two interfaces for this but I guess
that different user-space utilities use one or another. Maybe the
ChromiumOS folks can comment on this.

Best regards,
Javier
