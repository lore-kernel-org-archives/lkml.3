Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbaKPTcg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:32:36 -0500
Received: from mail-bl2on0095.outbound.protection.outlook.com ([65.55.169.95]:58069
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755457AbaKPTcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:32:35 -0500
Date: Sun, 16 Nov 2014 11:32:23 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Josh Cartwright <josh.cartwright@ni.com>, <monstr@monstr.eu>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v4 6/6] ARM: zynq: DT: Add OCM controller node
References: <cover.1415962281.git.michal.simek@xilinx.com>
 <0a88d52b5e71fb220ca619180ec9ca746edad2b1.1415962281.git.michal.simek@xilinx.com>
 <546881CA.2020801@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <546881CA.2020801@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21108.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <c52187589f5c4cc6b908d899c2b9f7a6@BN1BFFO11FD036.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(164054003)(189002)(24454002)(377424004)(51704005)(108616004)(104016003)(92566001)(23676002)(19580405001)(87936001)(110136001)(85182001)(6806004)(102836001)(46102003)(54356999)(95666004)(76176999)(74316001)(64706001)(31966008)(77096003)(106466001)(62966003)(120916001)(99396003)(33646002)(77156002)(4396001)(47776003)(20776003)(21056001)(53416004)(83506001)(86362001)(19580395003)(50466002)(85202003)(107046002)(50986999)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB039;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB039;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB039;
X-Forefront-PRVS: 039735BC4E
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB039;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-16 at 11:51AM +0100, Andreas Färber wrote:
> Hi Michal,
> 
> Am 14.11.2014 um 11:52 schrieb Michal Simek:
> > diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> > index ce2ef5bec4f2..e217fb1c1169 100644
> > --- a/arch/arm/boot/dts/zynq-7000.dtsi
> > +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> > @@ -150,6 +150,13 @@
> >  			reg = <0xf8006000 0x1000>;
> >  		};
> > 
> > +		ocmc: memory-controller@f800c000 {
> > +			compatible = "xlnx,zynq-ocmc-1.0";
> > +			interrupt-parent = <&intc>;
> > +			interrupts = <0 3 4>;
> > +			reg = <0xf800c000 0x1000>;
> > +		};
> > +
> >  		uart0: serial@e0000000 {
> >  			compatible = "xlnx,xuartps", "cdns,uart-r1p8";
> >  			status = "disabled";
> 
> Not directly related to this patch: As one can see here, the node order
> is quite a mess... According to Olof, nodes should be ordered by unit
> address, whereas here some but not all seem ordered by node name. Would
> you welcome a cleanup patch, or can you fix that yourself?

I wouldn't say it's a mess, just a different property to sort the nodes
by. For humans reading the DT, searching for nodes, alphabetical order
helps finding the right node, IMHO. What advantage would sorting by
address have?

	Thanks,
	Sören
