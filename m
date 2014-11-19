Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaKSFnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 00:43:08 -0500
Received: from mail-bl2on0145.outbound.protection.outlook.com ([65.55.169.145]:22893
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754666AbaKSFnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 00:43:06 -0500
Date: Wed, 19 Nov 2014 13:50:07 +0800
From: Robin Gong <b38343@freescale.com>
To: Soeren Moch <smoch@web.de>
CC: Shawn Guo <shawn.guo@linaro.org>, <kernel@pengutronix.de>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx6: add pm_power_off support for i.mx6
 chips
Message-ID: <20141119055006.GA27258@Robin-OptiPlex-780>
References: <1415780439-29728-1-git-send-email-b38343@freescale.com>
 <1415780439-29728-2-git-send-email-b38343@freescale.com>
 <20141119031823.GC27759@dragon> <546C2A13.3010307@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <546C2A13.3010307@web.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(24454002)(51704005)(62966003)(77156002)(104016003)(33716001)(31966008)(102836001)(95666004)(33656002)(105606002)(106466001)(93886004)(107046002)(97756001)(50986999)(54356999)(76176999)(46102003)(4396001)(110136001)(87936001)(85426001)(92726001)(92566001)(21056001)(23726002)(84676001)(44976005)(20776003)(47776003)(19580395003)(19580405001)(68736004)(99396003)(97736003)(120916001)(46406003)(50466002)(83506001)(64706001)(6806004)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0629;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Forefront-PRVS: 04004D94E2
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0648;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, the patch resent wrongly...
Hi Shawn, Can you apply the first v4 patches on Sep 26, or I resend it again? 
On Wed, Nov 19, 2014 at 06:26:43AM +0100, Soeren Moch wrote:
> 
> On 19.11.2014 04:18, Shawn Guo wrote:
> > On Wed, Nov 12, 2014 at 04:20:37PM +0800, Robin Gong wrote:
> >> All chips of i.mx6 can be powered off by programming SNVS.
> >> For example :
> >> On i.mx6q-sabresd board, PMIC_ON_REQ connect with external
> >> pmic ON/OFF pin, that will cause the whole PMIC powered off
> >> except VSNVS. And system can restart once PMIC_ON_REQ goes
> >> high by push POWRER key.
> >>
> >> Signed-off-by: Robin Gong <b38343@freescale.com>
> >> ---
> >>  arch/arm/boot/dts/imx6qdl-sabresd.dtsi |    4 ++++
> >>  arch/arm/boot/dts/imx6qdl.dtsi         |    6 ++++++
> >>  arch/arm/boot/dts/imx6sl-evk.dts       |    4 ++++
> >>  arch/arm/boot/dts/imx6sl.dtsi          |    6 ++++++
> >>  arch/arm/boot/dts/imx6sx-sdb.dts       |    4 ++++
> >>  arch/arm/boot/dts/imx6sx.dtsi          |    6 ++++++
> >>  6 files changed, 30 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> >> index 07fb302..ba12cc6 100644
> >> --- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> >> +++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> >> @@ -531,6 +531,10 @@
> >>  	status = "okay";
> >>  };
> >>  
> >> +&snvs-poweroff {
> >> +	status = "okay";
> >> +};"
> >> +
> >>  &ssi2 {
> >>  	status = "okay";
> >>  };
> >> diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
> >> index c701af9..3a032d1 100644
> >> --- a/arch/arm/boot/dts/imx6qdl.dtsi
> >> +++ b/arch/arm/boot/dts/imx6qdl.dtsi
> >> @@ -645,6 +645,12 @@
> >>  					interrupts = <0 19 IRQ_TYPE_LEVEL_HIGH>,
> >>  						     <0 20 IRQ_TYPE_LEVEL_HIGH>;
> >>  				};
> >> +
> >> +				snvs-poweroff: snvs-poweroff@38 {
> > 
> > I'm not sure if it's because my DTC version is too low or you didn't
> > test, the DTC reports error in label name 'snvs-poweroff'.  IIRC, hyphen
> > '-' cannot be used in label name, but underscore '_' can.
> > 
> > Shawn
> 
> In the patch series "[PATCH v4 0/3] add power off driver for i.mx6" from
> Sep 26 (what I have tested) snvs_poweroff was used. This worked as expected.
> 
> So this series "[PATCH v4 0/3] add power off driver for i.mx6" (sent on
> Nov 12) apparently contains old patches and is not simply resent as
> stated in the cover letter.
> 
> Soeren
