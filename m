Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab3KHUmB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 15:42:01 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:38269 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab3KHUl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 15:41:59 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1380315959.git.luto@amacapital.net>
References: <cover.1380315959.git.luto@amacapital.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 8 Nov 2013 12:41:38 -0800
Message-ID: <CALCETrX4-WHrCumnOxEoa53-2otNOPBFk_Q6yL3ufyhWbaJ1wQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] iMC SMBUS and DIMM bus probing
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <ruiv.wang@gmail.com>, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 6:02 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Intel LGA2011 machines have dedicated SMBUS controllers for DIMM
> sockets.  Because they're dedicated, they can be safely and accurately
> probed, since all devices on them are known to be attached to DIMMs.
> The devices found are:
>  - SPD EEPROMs
>  - TSODs (Temperature Sensor on DIMMs)
>  - Other interesting things, with drivers hopefully to follow...
>
> This patch series adds a simple generic layer for probing for DIMMs over
> SMBUS and an i2c bus driver for the iMC controller found on Intel
> LGA2011 chips.
>
> It now uses only modern infrastructure -- new-style I2C probing and the
> at24 (instead of eeprom) driver.
>
> I've tested this on a Core i7 Extreme and on a Xeon E5 server.
>
> Patches 1-3 are useful even without patch 4.  I'm still hoping for feedback
> on patch 4.
>
> Changes from v4:
>  - Added the sb_edac changes -- i2c_imc and sb_edac can now coexist
>  - Added some paranoid race detection.
>  - The driver now confirms its ability to claim software control of the SMBUS
>    master.  This prevents unpleasant problems on systems that enable CLTT
>    (closed loop thermal throttling).
>  - Reordered the patches so that the DIMM bus code is last.
>
> Changes from v3:
>  - Dropped redundant "tsod" driver
>  - Dropped eeprom modalias
>  - Switched to probing for the "eeprom" and "jc42"
>
> Andy Lutomirski (4):
>   Move Intel SNB device ids from sb_edac to pci_ids.h
>   sb_edac: Claim a different PCI device
>   i2c_imc: New driver for Intel's iMC, found on LGA2011 chips
>   i2c, i2c_imc: Add DIMM bus code
>
>  drivers/edac/sb_edac.c        |  32 +--
>  drivers/i2c/busses/Kconfig    |  19 ++
>  drivers/i2c/busses/Makefile   |   5 +
>  drivers/i2c/busses/dimm-bus.c |  97 ++++++++
>  drivers/i2c/busses/i2c-imc.c  | 562 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/dimm-bus.h  |  24 ++
>  include/linux/pci_ids.h       |  15 ++
>  7 files changed, 723 insertions(+), 31 deletions(-)
>  create mode 100644 drivers/i2c/busses/dimm-bus.c
>  create mode 100644 drivers/i2c/busses/i2c-imc.c
>  create mode 100644 include/linux/i2c/dimm-bus.h

Any update on these?  It would be nice to get them reviewed and applied.

Thanks,
Andy
