Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaDGJls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 05:41:48 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52699 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957AbaDGJlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 05:41:47 -0400
Message-ID: <1396863705.8506.39.camel@x220>
Subject: Re: [PATCH v6 01/36] mtd: st_spi_fsm: Allocate resources and
 register with MTD framework
From: Paul Bolle <pebolle@tiscali.nl>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, Angus.Clark@st.com
Date: Mon, 07 Apr 2014 11:41:45 +0200
In-Reply-To: <20140407091110.GB8888@lee--X1>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
	 <1395307268-12721-2-git-send-email-lee.jones@linaro.org>
	 <1396858351.8506.8.camel@x220> <20140407091110.GB8888@lee--X1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Apr 2014 09:41:45.0660 (UTC) FILETIME=[96FFC7C0:01CF5245]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-07 at 10:11 +0100, Lee Jones wrote:
> > > diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
> > > index 0128138..1210bc2 100644
> > > --- a/drivers/mtd/devices/Kconfig
> > > +++ b/drivers/mtd/devices/Kconfig
> > > @@ -210,6 +210,14 @@ config MTD_DOCG3
> > >  	  M-Systems and now Sandisk. The support is very experimental,
> > >  	  and doesn't give access to any write operations.
> > >  
> > > +config MTD_ST_SPI_FSM
> > > +	tristate "ST Microelectronics SPI FSM Serial Flash Controller"
> > > +	depends on ARM || SH
> > 
> > That should probably be
> >           depends on ARM || SUPERH
> 
> Actually it should be ARCH_STI, but thanks for the prompt.

I wouldn't have guessed that!

(Is ARCH_STI actually needed? ARCH_STI doesn't formally depend on ARM
but I don't think one can end up with a .config with ARCH_STI set
without ARM also set. Or am I mistaken?)

> > > +	help
> > > +	  This provides an MTD device driver for the ST Microelectronics
> > > +	  SPI Fast Sequence Mode (FSM) Serial Flash Controller and support
> > > +	  for a subset of connected Serial Flash devices.
> > > +
> > >  if MTD_DOCG3
> > >  config BCH_CONST_M
> > >  	default 14
> > 
> > Can this still be fixed in a future version of this series or should I
> > send a trivial patch?
> 
> Do you mean the SH thing, or are you now referencing something else?
> 
> If the former then I'm happy to send a fixup patch.

No, I was talking about the SH symbol. I'll gladly leave it up to you to
fix this.


Paul Bolle

