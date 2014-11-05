Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbaKEREH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:04:07 -0500
Received: from mail-bl2on0080.outbound.protection.outlook.com ([65.55.169.80]:63797
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932335AbaKERED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:04:03 -0500
Date: Wed, 5 Nov 2014 09:03:50 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Heiko Stuebner <heiko@sntech.de>, <linux-sh@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Olof Johansson <olof@lixom.net>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>
Subject: Re: [PATCH 0/7] Pinctrl support for Zynq
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
 <5459BC1C.3000807@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5459BC1C.3000807@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21076.007
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <44de30f0237545c6b62871d6c0480a67@BY2FFO11FD050.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(189002)(199003)(51704005)(24454002)(52604005)(107046002)(85202003)(31966008)(106466001)(95666004)(87936001)(102836001)(83506001)(85182001)(23676002)(76176999)(50986999)(575784001)(104016003)(54356999)(86362001)(53416004)(99396003)(47776003)(20776003)(108616004)(64706001)(19580395003)(120916001)(50466002)(6806004)(110136001)(77096003)(62966003)(92566001)(77156002)(46102003)(19580405001)(4396001)(44976005)(21056001)(74316001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB025;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB025;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 06:56AM +0100, Andreas Färber wrote:
> Hi Sören,
> 
> Am 03.11.2014 um 20:05 schrieb Soren Brinkmann:
> > Soren Brinkmann (7):
> >   pinctrl: pinconf-generic: Declare dt_params/conf_items const
> >   pinctrl: pinconf-generic: Infer map type from DT property
> >   pinctrl: pinconf-generic: Allow driver to specify DT params
> >   pinctrl: zynq: Document DT binding
> >   pinctrl: Add driver for Zynq
> >   ARM: zynq: Enable pinctrl
> >   ARM: zynq: DT: Add pinctrl information
> 
> Thanks for your work on this,
> 
> Tested-by: Andreas Färber <afaerber@suse.de>

Thanks for testing.

> 
> I've tracked down all 54 MIO pins of the Parallella and cooked up the
> equivalent DT patch. QSPI and USB still seem to be missing drivers
> upstream; I reused the SPI driver for the QSPI with pinctrl and
> Punnaiah's chipidea driver (not fully working) without pinctrl for lack
> of group/function definitions. For testing purposes I've configured a
> heartbeat trigger for the USER_LED (CR10).
> 
> To my disappointment these pinctrl additions did not fix one issue:
> Whenever a write access to be handled by the bitstream (0x808f0f04) is
> performed, the board hangs and the heartbeat stops. Would a bug in the
> bitstream allow this to happen, or are more drivers missing to actually
> make use of the PL in general? With a downstream ADI/Xilinx 3.12 kernel
> that problem does not surface.

This doesn't sound like being related to pinctrl at all.
Devices in the PL are just memory mapped on the AXI bus. There is
nothing needed to access those. Hangs do in most cases indicate that the
IP does not respond (properly). In my experience this is mostly caused
by 
 - level shifters not enabled
 - IP kept in reset
 - IP is clock gated
With the clock gating being the culprit in most cases. Did you check
those things?

	Sören
