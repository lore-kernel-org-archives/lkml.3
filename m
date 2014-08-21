Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaHUPtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:49:36 -0400
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:38979
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752138AbaHUPtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:49:32 -0400
Date: Thu, 21 Aug 2014 08:49:19 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com>
 <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl>
 <53F5D8D9.7040604@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F5D8D9.7040604@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199003)(377424004)(24454002)(479174003)(189002)(377454003)(164054003)(51704005)(92566001)(76482001)(85202003)(50986999)(20776003)(86362001)(102836001)(31966008)(50466002)(15975445006)(80022001)(93886004)(76176999)(81542001)(95666004)(70736001)(110136001)(6806004)(46102001)(99396002)(104016003)(87936001)(107046002)(81342001)(4396001)(85182001)(31696002)(21056001)(85852003)(23676002)(92726001)(64706001)(33646002)(83322001)(77982001)(44976005)(47776003)(85306004)(53416004)(77096002)(54356999)(19580405001)(83506001)(74502001)(106466001)(83072002)(575784001)(74662001)(74316001)(19580395003)(15202345003)(1496007)(79102001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB047;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 01:32PM +0200, Andreas Färber wrote:
> Am 21.08.2014 10:41, schrieb Michal Simek:
> > On 08/20/2014 05:56 PM, Soren Brinkmann wrote:
> >> Add missing Ethernet phys to Zynq DTs.
> >>
> >> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >> ---
> >>  arch/arm/boot/dts/zynq-zc702.dts | 6 ++++++
> >>  arch/arm/boot/dts/zynq-zc706.dts | 6 ++++++
> >>  arch/arm/boot/dts/zynq-zed.dts   | 6 ++++++
> >>  3 files changed, 18 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
> >> index 30bcfe20f0bc..fa810505ab8f 100644
> >> --- a/arch/arm/boot/dts/zynq-zc702.dts
> >> +++ b/arch/arm/boot/dts/zynq-zc702.dts
> >> @@ -36,6 +36,12 @@
> >>  &gem0 {
> >>  	status = "okay";
> >>  	phy-mode = "rgmii-id";
> >> +	phy-handle = <&ethernet_phy>;
> >> +
> >> +	ethernet_phy: ethernet-phy@7 {
> >> +		compatible = "marvell,88e1116r", "ethernet-phy-ieee802.3-c22";
> > 
> > c22 is completely unused by the kernel and also c22 is default option anyway.
> > Any advantage to have c22 specified here?
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/net/phy.txt
> 
> Sören's marvell,* entries do not seem documented, therefore I used the
> documented "ethernet-phy-idAAAA.BBBB" based syntax. The documented
> example specifically uses -c22, too.
> 
> Either it's okay to prepend unrecognized model strings, then you should
> update zynq-parallella.dts as well (I put the model in a comment there)
> or use the official strings like I used and keep the readable models as
> comments. Documenting all those "marvell,88e1116r", "marvell,88e1518",
> "marvell,88e1318" PHY bindings and possibly prepending them to the ID
> based strings would be another option, of course.

These phy-bindings are everything than obvious to me. It seems the docs
are spread across a couple of different files and not fully up to date
either. I basically tried to get something working out of the docs, the
parallela and our vendor DT files.

So my thinkings:
 - the compatible string with the -c22 is used and documented in the phy
   bindings, it should be there.
 - the ID based strings seem to be not needed since, IIUC, the core
   reads the ID from the PHY and uses it, so I just left it out not
   trying to figure out how to obtain the correct ID
 - the marvell compatible strings are used in our vendor tree. They
   aren't used anywhere but in our vendor tree. I though keeping them is
   nice since it identifies the PHY fully. And in case that level of
   detail is needed at some point it is already there.

Assuming that we wanna keep things this way, I'm happy to re-spin this
patch and also add a similar compatible string to the parallela DT.

	Thanks,
	Sören

