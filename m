Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab3CAO3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 09:29:54 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55148 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAO3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 09:29:53 -0500
MIME-Version: 1.0
In-Reply-To: <BAF0C2081321BA469F9ADF648F97D9B04C78FA607E@MCC023.weinmann.com>
References: <BAF0C2081321BA469F9ADF648F97D9B04C78FA6069@MCC023.weinmann.com>
 <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com>
 <BAF0C2081321BA469F9ADF648F97D9B04C78FA6071@MCC023.weinmann.com>
 <CACQ1gAg0rE+X+uxRWbrPKhmdS1T0MG00cwwBbzWM+VwU4zaXmw@mail.gmail.com>
 <BAF0C2081321BA469F9ADF648F97D9B04C78FA607C@MCC023.weinmann.com>
 <CACQ1gAg=L7ru5J4C7OQN0r-c2VN3baKX1qqty8Z0ObS5Wk48yg@mail.gmail.com> <BAF0C2081321BA469F9ADF648F97D9B04C78FA607E@MCC023.weinmann.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 1 Mar 2013 15:29:33 +0100
Message-ID: <CACQ1gAhJzy5tGSuejc3GqaqRxtHvkABOY-tODzedveeRXddvxQ@mail.gmail.com>
Subject: Re: Bug in mtd_get_device_size()?
To: "Velykokhatko, Sergey" <Sergey.Velykokhatko@mcc-med.de>
Cc: Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        Ricard Wanderlof <ricard.wanderlof@axis.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/1 Velykokhatko, Sergey <Sergey.Velykokhatko@mcc-med.de>:
> Hi Richard,
>
>>And if you want to tweak the BEB_LIMIT for each of your UBI partition, it's possible, via the ubiattach call ( get the master branchof of git://git.infradead.org/mtd-utils.git ) cf http://git.infradead.org/mtd-utils.git/commit/878e06ea555ba5dbfb974b3904d1a86a9a0e20f5
>
> Aha! I didn't see that before. In my case will be useful. Thanks for idea!
>
> Let I ask you one more question, probably you have better idea how to resolve it. If you have no other solution as my, should not answer. Also: as I mentioned before, I have one big partition with 4 UBI volumes on it: one of volumes will contain extreme important data (for example device type and serial number) and data on this volume will be written only several times for whole device life; and on other volume will be stored patient data that will be written relative often. Now in my SW that runs as init process I call ubiatach+mount. If ubiattach or mount for any of UBI volumes returns error, I call ubiformat+ubimkvol+mount again. This is normal use case when the device booted first time after production.
>With 2.6.38 and 3.3 kernel I had no problems but after update on 3.7 I got reported 2 cases when devices lost all their data.
Hum, that's clearly not normal.
> Unfortunately I have no additional information why it happened, but anyway is it really necessary to runs ubiformat+ubimkvol for such cases? Or is it possible to recover data?
I honestly don't know, but I'm sure Artem has some idea on that.
>Since my solution for this case is to put the device data in separate MTD with one single UBI volume. But you know how much space I should reserve on NAND MTD for single XML-File with 200Bytes :-).
I've got the same problem with uboot environment for example. It's
only some hundred bytes, and still I have to reserve the maximum bad
blocks number + 1 for the environment itself (so for your device 41).
I know, this looks overkill...
For 200bytes, I would try to store them elsewhere (spi dataflash,
eeprom...) if there's such devices on your board.
There's also the 1st block of the nand device which is guaranteed to
be "valid" for 1000 erase cycles (valid with 1-bit ECC per 528 bytes)

> Alternative is to try to mount only device volume, copy data in tmpfs, run ubiformat+ubimkvol+mount and copy the data back to the device volume. Or you have other idea?
>
> Thanks a lot,
> Best regards,
> Sergey
>

Best regards,
Richard.
