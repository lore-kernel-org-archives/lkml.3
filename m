Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab3FKV25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 17:28:57 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:23551
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154Ab3FKV2z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 17:28:55 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zz98dIc89bh936eI1432Ic8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Tue, 11 Jun 2013 14:28:41 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Dinh Nguyen <dinguyen@altera.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Shawn Guo <shawn.guo@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: dt: zynq: Add support for the zc706 platform
References: <1370884204-2297-1-git-send-email-soren.brinkmann@xilinx.com>
 <1370985888.7804.1.camel@linux-builds1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1370985888.7804.1.camel@linux-builds1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <785766f9-0d23-4a78-8638-fac05920049d@CO1EHSMHS013.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 04:24:48PM -0500, Dinh Nguyen wrote:
> Hi Soren,
> 
> On Mon, 2013-06-10 at 10:10 -0700, Soren Brinkmann wrote:
> > Add a DT fragment for the zc706 Zynq platform. Also, adding a
> > corresponding target to the Makefile and adding an appropriate
> > compatibility string in the BSP.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  arch/arm/boot/dts/Makefile       |  3 ++-
> >  arch/arm/boot/dts/zynq-zc706.dts | 31 +++++++++++++++++++++++++++++++
> >  arch/arm/mach-zynq/common.c      |  1 +
> >  3 files changed, 34 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/arm/boot/dts/zynq-zc706.dts
> > 
> > diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> > index b9f7121..2aecf7e 100644
> > --- a/arch/arm/boot/dts/Makefile
> > +++ b/arch/arm/boot/dts/Makefile
> > @@ -206,7 +206,8 @@ dtb-$(CONFIG_ARCH_VT8500) += vt8500-bv07.dtb \
> >  	wm8505-ref.dtb \
> >  	wm8650-mid.dtb \
> >  	wm8850-w70v2.dtb
> > -dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb
> > +dtb-$(CONFIG_ARCH_ZYNQ) += zynq-zc702.dtb \
> > +	zynq-zc706.dtb
> >  
> >  targets += dtbs
> >  targets += $(dtb-y)
> > diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
> > new file mode 100644
> > index 0000000..a8a1d7d
> > --- /dev/null
> > +++ b/arch/arm/boot/dts/zynq-zc706.dts
> > @@ -0,0 +1,31 @@
> > +/*
> > + *  Copyright (C) 2011 Xilinx
> > + *  Copyright (C) 2012 National Instruments Corp.
> > + *  Copyright (C) 2013 Xilinx
> > + *
> > + * This software is licensed under the terms of the GNU General Public
> > + * License version 2, as published by the Free Software Foundation, and
> > + * may be copied, distributed, and modified under those terms.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +/dts-v1/;
> > +/include/ "zynq-7000.dtsi"
> > +
> > +/ {
> > +	model = "Zynq ZC706 Development Board";
> > +	compatible = "xlnx,zynq-zc706", "xlnx,zynq-7000";
> > +
> > +	memory {
> > +		device_type = "memory";
> > +		reg = <0x0 0x40000000>;
> > +	};
> > +
> > +	chosen {
> > +		bootargs = "console=ttyPS1,115200 earlyprintk";
> > +	};
> > +
> > +};
> > diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> > index 5bfe703..221694b 100644
> > --- a/arch/arm/mach-zynq/common.c
> > +++ b/arch/arm/mach-zynq/common.c
> > @@ -99,6 +99,7 @@ static void zynq_system_reset(char mode, const char *cmd)
> >  
> >  static const char * const zynq_dt_match[] = {
> >  	"xlnx,zynq-zc702",
> > +	"xlnx,zynq-zc706",
> 
> You really don't need to add zc706 here if it is already compatable with
> zynq-7000.
I actually thought about this and decided to add it, since there already
was an entry for the zc702. What is the best methord for this cases?
Rather remove the specific ones and migrate all to the zynq-7000
compatibility string?

	Sören


