Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbaAHOd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:33:26 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54337 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaAHOdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:33:23 -0500
Date: Wed, 8 Jan 2014 14:33:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, angus.clark@st.com,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v4 00/36] mtd: st_spi_fsm: Add new driver
Message-ID: <20140108143316.GA14575@lee--X1>
References: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389188840-14306-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ing the MTD ML. Sorry guys.

If you're interested in the set, it went to LKML and LAKML.

Let me know if you want to send the full set again with the MTD ML
CC'ed.

Hopefully you can do without though, as I'm cautious of not crating
lots of churn. 

> Version 4:
>   Tended to Brian's previous review comments
>     - Checkpatch acceptance
>     - MODULE_DEVICE_TABLE() name slip correction
>     - Timeout issue(s) resolved
>     - Potential infinite loop mitigated
>     - Code clarity suggests heeded
>     - Duplication with MTD core code removed
>     - Upgraded to using ROUND_UP() helper
>     - Moved non-shared header code into main driver
>     - Relocated dynamic msg sequence stores into main struct
>     - Averted adaption of static (table) data
>     - Basic whitespace/spelling/data type/dev_err suggestions accepted
> 
> Version 3:
>   Okay, this thing should be fully functional now. Identify a chip
>   based on it's JEDEC ID, Read, Write, Erase (all or by sector).
>   Support for various chip quirks added too.
>  
> Version 2:
>   The first bunch of these patches have been on the MLs before, but
>   didn't receive a great deal of attention for the most part. We are
>   a little more featureful this time however. We can now successfully
>   setup and configure the N25Q256. We still can't read/write/erase
>   it though. I'll start work on that next week and will provide it in
>   the next instalment.
>  
> Version 1:
>   First stab at getting this thing Mainlined. It doesn't do a great deal
>   yet, but we are able to initialise the device and dynamically set it up
>   correctly based on an extracted JEDEC ID.
> 
>  Documentation/devicetree/bindings/mtd/st-fsm.txt |   26 ++
>  arch/arm/boot/dts/stih416-b2105.dts              |   14 +
>  arch/arm/boot/dts/stih416-pinctrl.dtsi           |   12 +
>  drivers/mtd/devices/Kconfig                      |    8 +
>  drivers/mtd/devices/Makefile                     |    1 +
>  drivers/mtd/devices/serial_flash_cmds.h          |   81 ++++
>  drivers/mtd/devices/st_spi_fsm.c                 | 2124 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 2266 insertions(+)


-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
