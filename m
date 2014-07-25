Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbaGYOuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:50:01 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:5179
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753105AbaGYOt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:49:59 -0400
Date: Fri, 25 Jul 2014 07:49:47 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 08/11] ARM: dts: zynq: Add VDMA to Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-9-git-send-email-afaerber@suse.de>
 <b4c4e060-2efb-4b82-be12-32c00897ec93@BY2FFO11FD023.protection.gbl>
 <53D22799.8050903@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D22799.8050903@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <f0a06d6e-e10a-48c1-91a3-fc99f4a772b4@BN1AFFO11FD044.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377424004)(51704005)(199002)(189002)(83072002)(104016003)(76176999)(102836001)(85202003)(20776003)(64706001)(92726001)(79102001)(74316001)(47776003)(50986999)(31696002)(54356999)(85852003)(575784001)(76482001)(53416004)(80022001)(95666004)(33646002)(77096002)(81342001)(19580405001)(74502001)(46102001)(81542001)(77982001)(4396001)(99396002)(83506001)(92566001)(1496007)(15975445006)(107046002)(31966008)(106466001)(50466002)(83322001)(74662001)(19580395003)(44976005)(86362001)(15202345003)(87936001)(85306003)(110136001)(23676002)(21056001)(85182001)(70736001)(93886003)(6806004)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB025;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 11:47AM +0200, Andreas Färber wrote:
> Hi Sören,
> 
> Am 25.07.2014 01:22, schrieb Sören Brinkmann:
> > On Fri, 2014-07-25 at 01:00AM +0200, Andreas Färber wrote:
> >> Signed-off-by: Andreas Färber <afaerber@suse.de>
> >> ---
> >>  v2: New
> >>  
> >>  arch/arm/boot/dts/zynq-parallella.dts | 25 +++++++++++++++++++++++++
> >>  1 file changed, 25 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
> >> index e60a0a9..8beaacc 100644
> >> --- a/arch/arm/boot/dts/zynq-parallella.dts
> >> +++ b/arch/arm/boot/dts/zynq-parallella.dts
> >> @@ -32,6 +32,31 @@
> >>  		bootargs = "console=ttyPS0,115200 earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait";
> >>  		linux,stdout-path = "/amba/serial@e0001000";
> >>  	};
> >> +
> >> +	fpga {
> > Do you really want FPGA components in this DT?
> > If somebody tries booting with this DT without programming with a
> > corresponding bitstream, the whole system might hang.
> > Just something to consider.
> 
> Well, that's related to a question that remained unanswered on v1:
> whether we may need to turn this into a .dtsi to cope with variations.
> 
> The Parallella has an on-board µHDMI connector, and two bitstreams are
> delivered - one for HDMI and one for headless usage. In my testing I am
> using the original HDMI bitstream but serial console for lack of
> upstream HDMI drivers. Do you think we need to provide
> zynq-parallella-hdmi.dts and zynq-parallella-headless.dts? (It gets
> worse if at some point we need to handle variations of the on-board
> Epiphany chip plus the bitstreams - at least the Z7010 vs. Z7020 doesn't
> affect DT AFAICT.)
> 
> Since, as noted in the cover letter, these FPGA patches are not yet
> fully testable, I wouldn't mind deferring them, but wanted to get them
> out for review early.
> 
> http://www.parallella.org/2014/07/14/new-parallella-product-offerings/
> indicates there will be a new variation in gen2 without USB/HDMI. Would
> it be valid to #include a .dts (rather than .dtsi) to override status
> and keep number of Parallella files low?

For these FPGA devices, it would be nice if it was possible to include
a dts file. I think there were problems with that, but don't know what
the current status of that is. Then it would be possible to have the SOC
dtsi a board dts and systems with FPGA components can include the board
dts.
I also heard that some people are getting upset with all the includes
going on in the dts files.

And the next question would be: How many dts files do you really want
in the upstream kernel tree? Since we deal with FPGAs, there is
virtually and infinite number of different systems that you could
create relatively easily.

	Sören

