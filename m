Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbaDGJLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 05:11:20 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59519 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbaDGJLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 05:11:17 -0400
Date: Mon, 7 Apr 2014 10:11:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, Angus.Clark@st.com
Subject: Re: [PATCH v6 01/36] mtd: st_spi_fsm: Allocate resources and
 register with MTD framework
Message-ID: <20140407091110.GB8888@lee--X1>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
 <1395307268-12721-2-git-send-email-lee.jones@linaro.org>
 <1396858351.8506.8.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396858351.8506.8.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is a new driver. It's used to communicate with a special type of
> > optimised Serial Flash Controller called the FSM. The FSM uses a subset
> > of the SPI protocol to communicate with supported NOR-Flash devices.
> > 
> > Acked-by Angus Clark <angus.clark@st.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> This patch seems to be commit d90db4a07429 ("mtd: st_spi_fsm: Allocate
> resources and register with MTD framework") in current linux-next. 
> 
> > ---
> >  drivers/mtd/devices/Kconfig      |   8 +++
> >  drivers/mtd/devices/Makefile     |   1 +
> >  drivers/mtd/devices/st_spi_fsm.c | 106 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 115 insertions(+)
> >  create mode 100644 drivers/mtd/devices/st_spi_fsm.c
> > 
> > diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> > index 0128138..1210bc2 100644
> > --- a/drivers/mtd/devices/Kconfig
> > +++ b/drivers/mtd/devices/Kconfig
> > @@ -210,6 +210,14 @@ config MTD_DOCG3
> >  	  M-Systems and now Sandisk. The support is very experimental,
> >  	  and doesn't give access to any write operations.
> >  
> > +config MTD_ST_SPI_FSM
> > +	tristate "ST Microelectronics SPI FSM Serial Flash Controller"
> > +	depends on ARM || SH
> 
> That should probably be
>           depends on ARM || SUPERH

Actually it should be ARCH_STI, but thanks for the prompt.

> > +	help
> > +	  This provides an MTD device driver for the ST Microelectronics
> > +	  SPI Fast Sequence Mode (FSM) Serial Flash Controller and support
> > +	  for a subset of connected Serial Flash devices.
> > +
> >  if MTD_DOCG3
> >  config BCH_CONST_M
> >  	default 14
> 
> Can this still be fixed in a future version of this series or should I
> send a trivial patch?

Do you mean the SH thing, or are you now referencing something else?

If the former then I'm happy to send a fixup patch.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
