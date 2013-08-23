Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3HWJey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 05:34:54 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:27051
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753454Ab3HWJew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 05:34:52 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 23 Aug 2013 17:36:02 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <b29396@freescale.com>
CC: Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>,
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] of: add update device node status via cmdline feature
Message-ID: <20130823093559.GA10662@S2101-09.ap.freescale.net>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
 <CACxGe6tMm=u1jFKUQ59+cj-rYkLLAZUqMhsXamyi-wwpWaOGvw@mail.gmail.com>
 <20130821123708.GA17748@b29396-Latitude-E6410>
 <20130823070906.GA2460@b29396-Latitude-E6410>
 <20130823075102.GA10424@S2101-09.ap.freescale.net>
 <20130823084954.GC2460@b29396-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130823084954.GC2460@b29396-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 04:49:55PM +0800, Dong Aisheng wrote:
> On Fri, Aug 23, 2013 at 03:51:07PM +0800, Shawn Guo wrote:
> > The device tree mailing list is changed to devicetree@vger.kernel.org.
> > 
> > On Fri, Aug 23, 2013 at 03:09:08PM +0800, Dong Aisheng wrote:
> > > I tried the uboot way with fdt command to change the node status, it can work.
> > > However, it seems using fdt command is much complicated than the way i did with kernel
> > > command line and it also does not support enable/disable multi nodes at the same time.
> > > e.g, in order to enable ecspi1 and uart3 and disable gpmi:
> > > with uboot fdt command:
> > > U-Boot > fdt addr ${dtbaddr}
> > > U-Boot > fdt set /soc/aips-bus@02000000/spba-bus@02000000/ecspi@02008000 status "okay"
> > > U-Boot > fdt set /soc/aips-bus@02100000/serial@021e8000 status "okay"
> > > U-Boot > fdt set /soc/gpmi-nand@00112000 status "disabled"
> > 
> > Oh, you can use the U-Boot environment and scripting function to make
> > it even easier than your kernel cmdline approach to use.
> > 
> 
> Hmm?
> Can you give an example to make it easier than kernel cmdline?

For imx6q-sabreauto example,

setenv loadaddr 0x12000000
setenv fdtaddr 0x18000000
setenv fdt_file imx6q-sabreauto.dtb

setenv bootcmd 'tftpboot zImage; tftpboot ${fdtaddr} ${fdt_file}; fdt addr ${fdtaddr}; run select_${devsel}; bootz ${loadaddr} - ${fdtaddr}'

setenv select_gpmi 'fdt set /soc/aips-bus@02000000/spba-bus@02000000/ecspi@02008000 status disabled; fdt set /soc/aips-bus@02100000/serial@021e8000 status disabled; fdt set /soc/gpmi-nand@00112000 status okay'
setenv select_ecspi '...'
setenv select_serial '...'

You can have all above environments defined in U-Boot mx6qsabreauto.h
at compile time.  Then at runtime, you only need the following two
commands to boot kernel with the device that you want.

U-Boot > setenv devsel gpmi
U-Boot > boot

Shawn

