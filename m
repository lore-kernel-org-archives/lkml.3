Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbaGYOn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:43:59 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:40644
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754102AbaGYOn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:43:58 -0400
Date: Fri, 25 Jul 2014 07:43:44 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 06/11] ARM: dts: zynq: Add DMAC for Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de>
 <1406242820-20140-7-git-send-email-afaerber@suse.de>
 <bc390439-9a5b-43a1-a70c-a4c6517a6cb6@BN1AFFO11FD005.protection.gbl>
 <53D20F2A.5020209@monstr.eu> <53D21458.3060403@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D21458.3060403@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <9d1e0d28-1fa2-4ef4-9d6f-b64829223f74@BN1AFFO11FD021.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(479174003)(377424004)(377454003)(51704005)(199002)(189002)(83072002)(104016003)(76176999)(102836001)(85202003)(20776003)(64706001)(92726001)(79102001)(74316001)(47776003)(50986999)(31696002)(54356999)(85852003)(76482001)(53416004)(80022001)(95666004)(33646002)(77096002)(81342001)(19580405001)(74502001)(46102001)(81542001)(77982001)(4396001)(99396002)(83506001)(92566001)(1496007)(107046002)(31966008)(106466001)(50466002)(83322001)(74662001)(19580395003)(44976005)(86362001)(87936001)(85306003)(110136001)(23676002)(21056001)(85182001)(70736001)(93886003)(6806004)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB025;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02830F0362
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-25 at 10:24AM +0200, Andreas Färber wrote:
> Am 25.07.2014 10:02, schrieb Michal Simek:
> > On 07/25/2014 01:28 AM, Sören Brinkmann wrote:
> >> On Fri, 2014-07-25 at 01:00AM +0200, Andreas Färber wrote:
> >>> Signed-off-by: Andreas Färber <afaerber@suse.de>
> >>> ---
> >>>  v2: New
> >>>  
> >>>  arch/arm/boot/dts/zynq-7000.dtsi      | 17 +++++++++++++++++
> >>>  arch/arm/boot/dts/zynq-parallella.dts |  4 ++++
> >>>  2 files changed, 21 insertions(+)
> >>>
> >>> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> >>> index eed3df0..1a70277 100644
> >>> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> >>> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> >>> @@ -223,6 +223,23 @@
> >>>  			};
> >>>  		};
> >>>  
> >>> +		dmac_s: dmac@f8003000 {
> >>> +			compatible = "arm,pl330", "arm,primecell";
> >>> +			reg = <0xf8003000 0x1000>;
> >>> +			status = "disabled";
> >> I think for this IP we can omit the 'status' property since it is always
> >> enabled. I don't see a reason to override it in each board DT.
> > 
> > Done this change myself
> 
> Fine with me, but allow me to point out that the TRM documents the DMAC
> being mapped as DMAC S at the above address, and as DMAC NS at F800_4000
> (secure vs. non-secure, ch. 4.6, p. 116). Not sure how this would be
> handled driver-wise if not through alternative dt nodes?

The upstream Linux runs in secure state on Zynq, hence I think this is fine. If
somebody wants to run Linux on Zynq non-secure they have to do some work
anyhow. This way the standard configuration can use the DMA engine.

	Sören

