Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaLAVZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:25:15 -0500
Received: from mail-bn1bon0085.outbound.protection.outlook.com ([157.56.111.85]:1680
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932389AbaLAVZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:25:12 -0500
Date: Mon, 1 Dec 2014 13:24:59 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Michal Simek <michal.simek@xilinx.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Ola Jeppson <ola@adapteva.com>
Subject: Re: [PATCH] ARM: zynq: DT: Add USB to device tree
References: <1417459352-23401-1-git-send-email-soren.brinkmann@xilinx.com>
 <547CCEE3.6020806@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547CCEE3.6020806@suse.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21144.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <fb6f17c51aef4a498eb2a3e01a81df34@BN1BFFO11FD017.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(199003)(377424004)(189002)(24454002)(83506001)(120916001)(106466001)(46102003)(86362001)(62966003)(99396003)(74316001)(53416004)(77156002)(23676002)(77096004)(95666004)(85202003)(104016003)(92566001)(33646002)(110136001)(108616004)(76176999)(54356999)(50986999)(19580395003)(19580405001)(107046002)(6806004)(44976005)(87936001)(85182001)(102836001)(4396001)(47776003)(31966008)(21056001)(20776003)(64706001)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB020;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB020;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB020;
X-Forefront-PRVS: 0412A98A59
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB020;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-12-01 at 09:26PM +0100, Andreas Färber wrote:
> Hi Sören,
> 
> Am 01.12.2014 um 19:42 schrieb Soren Brinkmann:
> > Add USB nodes to zc702, zc706 and zed device trees.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  arch/arm/boot/dts/zynq-7000.dtsi | 22 +++++++++++++++++++++-
> >  arch/arm/boot/dts/zynq-zc702.dts | 11 +++++++++++
> >  arch/arm/boot/dts/zynq-zc706.dts | 10 ++++++++++
> >  arch/arm/boot/dts/zynq-zed.dts   | 10 ++++++++++
> >  4 files changed, 52 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> > index ce2ef5bec4f2..9ed60938f301 100644
> > --- a/arch/arm/boot/dts/zynq-7000.dtsi
> > +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> > @@ -315,6 +315,26 @@
> >  			clocks = <&clkc 4>;
> >  		};
> >  
> > +		usb0: usb@e0002000 {
> > +			compatible = "xlnx,zynq-usb-2.20a", "chipidea,usb2";
> > +			status = "disabled";
> > +			clocks = <&clkc 28>;
> > +			interrupt-parent = <&intc>;
> > +			interrupts = <0 21 4>;
> > +			reg = <0xe0002000 0x1000>;
> > +			phy_type = "ulpi";
> > +		};
> > +
> > +		usb1: usb@e0003000 {
> > +			compatible = "xlnx,zynq-usb-2.20a", "chipidea,usb2";
> > +			status = "disabled";
> > +			clocks = <&clkc 29>;
> > +			interrupt-parent = <&intc>;
> > +			interrupts = <0 44 4>;
> > +			reg = <0xe0003000 0x1000>;
> > +			phy_type = "ulpi";
> > +		};
> > +
> >  		watchdog0: watchdog@f8005000 {
> >  			clocks = <&clkc 45>;
> >  			compatible = "xlnx,zynq-wdt-r1p2";
> 
> This part looks good.
> 
> > @@ -324,6 +344,6 @@
> >  			reg = <0xf8005000 0x1000>;
> >  			reset = <0>;
> >  			timeout-sec = <10>;
> > -		};
> > +		} ;
> >  	};
> >  };
> 
> Unrelated accidental change here though. :)
> 
> Did I miss a matching series actually implementing the driver? I'd need
> to test the latest version to determine how to update the Parallella
> device tree - I assume that USB0 is in dr_mode="host", but with the
> previous patchsets I was unable to verify. CC'ing Ola.

It was merged to the USB tree recently. I tested this on linux-next.

	Sören
