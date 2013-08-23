Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3HWHuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:50:01 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:50266 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623Ab3HWHt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:49:59 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 23 Aug 2013 15:51:07 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
CC: Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>,
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] of: add update device node status via cmdline feature
Message-ID: <20130823075102.GA10424@S2101-09.ap.freescale.net>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
 <CACxGe6tMm=u1jFKUQ59+cj-rYkLLAZUqMhsXamyi-wwpWaOGvw@mail.gmail.com>
 <20130821123708.GA17748@b29396-Latitude-E6410>
 <20130823070906.GA2460@b29396-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130823070906.GA2460@b29396-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree mailing list is changed to devicetree@vger.kernel.org.

On Fri, Aug 23, 2013 at 03:09:08PM +0800, Dong Aisheng wrote:
> I tried the uboot way with fdt command to change the node status, it can work.
> However, it seems using fdt command is much complicated than the way i did with kernel
> command line and it also does not support enable/disable multi nodes at the same time.
> e.g, in order to enable ecspi1 and uart3 and disable gpmi:
> with uboot fdt command:
> U-Boot > fdt addr ${dtbaddr}
> U-Boot > fdt set /soc/aips-bus@02000000/spba-bus@02000000/ecspi@02008000 status "okay"
> U-Boot > fdt set /soc/aips-bus@02100000/serial@021e8000 status "okay"
> U-Boot > fdt set /soc/gpmi-nand@00112000 status "disabled"

Oh, you can use the U-Boot environment and scripting function to make
it even easier than your kernel cmdline approach to use.

> with kernel cmdline:
> fdt.enable=ecspi@02008000,serial@021e8000 fdt.disable=gpmi-nand@00112000
> So from the using perspective, kernel command line is much more simple and easy than uboot.

NAK.

It's not about simple or easy.  The approach completely defects the
point of the whole device tree project - moving stuff that kernel does
not care out of kernel.  Choosing device from mutually exclusive ones
(due to pin conflict of board design) should NOT be something that
kernel cares.

Kernel gets device tree blob from firmware/bootloader and instantiates
drivers for devices found in device tree.  That's all what kernel should
do, nothing more.  Asking kernel to manipulate the device availability
property in device tree is plainly wrong to me.

If your board is designed with so many pin conflicts between devices,
you have to do whatever you can do to get the decision made in device
tree blob, before it gets passed to kernel.  Kernel does NOT care about
that decision making.

Shawn

