Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaBNKrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:47:05 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44604 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaBNKrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:47:02 -0500
Date: Fri, 14 Feb 2014 10:46:55 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Angus Clark <Angus.Clark@st.com>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org, computersforpeace@gmail.com,
        DCG_UPD_stlinux_kernel@list.st.com, olivier.clergeaud@st.com
Subject: Re: [PATCH RESEND v4 00/37] mtd: st_spi_fsm: Add new driver
Message-ID: <20140214104655.GE9462@lee--X1>
References: <1390473085-24626-1-git-send-email-lee.jones@linaro.org>
 <52FA3B1A.2070304@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52FA3B1A.2070304@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry for the delay.  I have now had a quick look through the patches.  Just a
> couple of points :-)
> 
> * stfsm_probe(): stfsm_fetch_platform_configs() needs to be called *before*
> config() -- config() is based on platform capabilities.  Conceptually,
> stfsm_fetch_platform_configs() should be called before stfsm_jedec_probe(), and
> FLASH_FLAG_32BIT_ADDR should be moved out of stfsm_fetch_platform_configs(),
> placed just after stfsm_jedec_probe() but before config().
> 
> * fsm_wait_busy(): logic not quite correct if we get a P_ERR or E_ERR error
> after a timeout.  I am also not sure about returning (uint8_t)-EIO.  For what
> its worth, this is what I did in response to Brian's comment about the race
> condition:

Thanks Angus.

Brain,

If I fix up the review comments from  Angus', Ludovic and Christophe
are you happy to finally accept the driver? Or do you have any final
review comments that you wish me to apply for v5?

> On 01/23/2014 10:30 AM, Lee Jones wrote:
> > Version 4:
> >   Tended to Brian's review comments
> >     - Checkpatch acceptance
> >     - MODULE_DEVICE_TABLE() name slip correction
> >     - Timeout issue(s) resolved
> >     - Potential infinite loop mitigated
> >     - Code clarity suggests heeded
> >     - Duplication with MTD core code removed
> >     - Upgraded to using ROUND_UP() helper
> >     - Moved non-shared header code into main driver
> >     - Relocated dynamic msg sequence stores into main struct
> >     - Averted adaption of static (table) data
> >     - Basic whitespace/spelling/data type/dev_err suggestions applied
> >   
> > Version 3:
> >   Okay, this thing should be fully functional now. Identify a chip
> >   based on it's JEDEC ID, Read, Write, Erase (all or by sector).
> >   Support for various chip quirks added too.
> > 
> > Version 2:
> >   The first bunch of these patches have been on the MLs before, but
> >   didn't receive a great deal of attention for the most part. We are
> >   a little more featureful this time however. We can now successfully
> >   setup and configure the N25Q256. We still can't read/write/erase
> >   it though. I'll start work on that next week and will provide it in
> >   the next instalment.
> > 
> > Version 1:
> >   First stab at getting this thing Mainlined. It doesn't do a great deal
> >   yet, but we are able to initialise the device and dynamically set it up
> >   correctly based on an extracted JEDEC ID.
> > 
> >  Documentation/devicetree/bindings/mtd/st-fsm.txt |   26 ++
> >  arch/arm/boot/dts/stih416-b2105.dts              |   14 +
> >  arch/arm/boot/dts/stih416-pinctrl.dtsi           |   12 +
> >  drivers/mtd/devices/Kconfig                      |    8 +
> >  drivers/mtd/devices/Makefile                     |    1 +
> >  drivers/mtd/devices/serial_flash_cmds.h          |   81 ++++
> >  drivers/mtd/devices/st_spi_fsm.c                 | 2124 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > 7 files changed, 2266 insertions(+)
> > 
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
