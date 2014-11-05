Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbaKESJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:09:49 -0500
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:64977
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbaKESJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:09:45 -0500
X-Greylist: delayed 3542 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2014 13:09:45 EST
Date: Wed, 5 Nov 2014 10:09:35 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        <linux-rockchip@lists.infradead.org>, <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 2/7] pinctrl: pinconf-generic: Infer map type from DT
 property
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
 <1415041531-15520-3-git-send-email-soren.brinkmann@xilinx.com>
 <21124316.ibhe1N9UZS@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <21124316.ibhe1N9UZS@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21076.007
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <d0c8876b424049059acab000d07ffa4b@BN1AFFO11FD053.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(24454002)(164054003)(377424004)(51704005)(189002)(50986999)(106466001)(85202003)(104016003)(110136001)(108616004)(23676002)(33646002)(107046002)(85182001)(87936001)(50466002)(99396003)(95666004)(77156002)(21056001)(62966003)(77096003)(46102003)(4396001)(92566001)(74316001)(86362001)(102836001)(53416004)(83506001)(120916001)(31966008)(20776003)(47776003)(64706001)(76176999)(6806004)(44976005)(54356999)(19580395003)(41533002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB055;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB055;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 03:56PM +0200, Laurent Pinchart wrote:
> Hi Soren,
> 
> Thank you for the patch.
> 
> On Monday 03 November 2014 11:05:26 Soren Brinkmann wrote:
> > With the new 'groups' property, the DT parser can infer the map type
> > from the fact whether 'pins' or 'groups' is used to specify the pin
> > group to work on.
> > To maintain backwards compatibitliy with current usage of the DT
> > binding, this is only done when an invalid map type is passed to the
> > parsing function.
> 
> The Renesas PFC implements similar bindings with using the vendor-specific 
> properties "renesas,pins" and "renesas,groups" (bindings and implementation 
> available at Documentation/devicetree/bindings/pinctrl/renesas,pfc-pinctrl.txt 
> and drivers/pinctrl/sh-pfc/pinctrl.c respectively).
> 
> The Renesas implementation is a bit more generic in that it allows both pins 
> and groups to be specified in a single subnode. Do you think that feature 
> would make sense for pinconf-generic as well ?

I don't have a use-case for that. I guess if somebody needs this kind of
functionality it could be added later. I would like to avoid blocking
pinctrl-zynq on adding more features here.

	Thanks,
	Sören
