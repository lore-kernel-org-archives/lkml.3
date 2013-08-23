Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3HWIuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:50:08 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:13449
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553Ab3HWIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:50:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1155h)
Date: Fri, 23 Aug 2013 16:49:55 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>,
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] of: add update device node status via cmdline feature
Message-ID: <20130823084954.GC2460@b29396-Latitude-E6410>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
 <CACxGe6tMm=u1jFKUQ59+cj-rYkLLAZUqMhsXamyi-wwpWaOGvw@mail.gmail.com>
 <20130821123708.GA17748@b29396-Latitude-E6410>
 <20130823070906.GA2460@b29396-Latitude-E6410>
 <20130823075102.GA10424@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130823075102.GA10424@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 03:51:07PM +0800, Shawn Guo wrote:
> The device tree mailing list is changed to devicetree@vger.kernel.org.
> 
> On Fri, Aug 23, 2013 at 03:09:08PM +0800, Dong Aisheng wrote:
> > I tried the uboot way with fdt command to change the node status, it can work.
> > However, it seems using fdt command is much complicated than the way i did with kernel
> > command line and it also does not support enable/disable multi nodes at the same time.
> > e.g, in order to enable ecspi1 and uart3 and disable gpmi:
> > with uboot fdt command:
> > U-Boot > fdt addr ${dtbaddr}
> > U-Boot > fdt set /soc/aips-bus@02000000/spba-bus@02000000/ecspi@02008000 status "okay"
> > U-Boot > fdt set /soc/aips-bus@02100000/serial@021e8000 status "okay"
> > U-Boot > fdt set /soc/gpmi-nand@00112000 status "disabled"
> 
> Oh, you can use the U-Boot environment and scripting function to make
> it even easier than your kernel cmdline approach to use.
> 

Hmm?
Can you give an example to make it easier than kernel cmdline?

First it seems the full path name can not be reduced.
Second i'm not clear but can it get the same function that manipulating multi
nodes at the same time as kernel cmdline does?

> > with kernel cmdline:
> > fdt.enable=ecspi@02008000,serial@021e8000 fdt.disable=gpmi-nand@00112000
> > So from the using perspective, kernel command line is much more simple and easy than uboot.
> 
> NAK.
> 
> It's not about simple or easy.  The approach completely defects the
> point of the whole device tree project - moving stuff that kernel does
> not care out of kernel.  Choosing device from mutually exclusive ones
> (due to pin conflict of board design) should NOT be something that
> kernel cares.
> 
> Kernel gets device tree blob from firmware/bootloader and instantiates
> drivers for devices found in device tree.  That's all what kernel should
> do, nothing more.  Asking kernel to manipulate the device availability
> property in device tree is plainly wrong to me.
> 

We all know this basic rule and i'm not against it.
Why the patch is sent is because there are already many places in kernel manipulate
the device node at runtime as exceptional cases.
And i'm wondering if we can take this as exception too since this function does
help users.

If we can find a better idea to fix this issue without this patch,
i definitely would agree with it.

Regards
Dong Aisheng

> If your board is designed with so many pin conflicts between devices,
> you have to do whatever you can do to get the decision made in device
> tree blob, before it gets passed to kernel.  Kernel does NOT care about
> that decision making.
> 

