Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaKLSng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:43:36 -0500
Received: from mail-bn1bon0093.outbound.protection.outlook.com ([157.56.111.93]:38913
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753100AbaKLSne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:43:34 -0500
Date: Wed, 12 Nov 2014 10:43:25 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 2/7] pinctrl: pinconf-generic: Infer map type from DT
 property
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
 <1415041531-15520-3-git-send-email-soren.brinkmann@xilinx.com>
 <21124316.ibhe1N9UZS@avalon>
 <CACRpkdZH9b_KB9Mz8r5vj=KGqr0bJeKMRgODUbNeBDVNr=tsCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZH9b_KB9Mz8r5vj=KGqr0bJeKMRgODUbNeBDVNr=tsCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21096.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <67efe9ba5e634b3cb925ab4d68e59726@BL2FFO11FD023.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(189002)(51704005)(199003)(377454003)(24454002)(104016003)(19580395003)(102836001)(4396001)(107046002)(85182001)(95666004)(31966008)(87936001)(6806004)(44976005)(62966003)(47776003)(76176999)(54356999)(50986999)(53416004)(83506001)(86362001)(120916001)(93886004)(19580405001)(92566001)(46102003)(99396003)(23676002)(108616004)(20776003)(77096003)(85202003)(77156002)(110136001)(106466001)(64706001)(21056001)(74316001)(50466002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB007;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB007;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB007;
X-Forefront-PRVS: 03932714EB
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB007;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 01:29PM +0100, Linus Walleij wrote:
> On Wed, Nov 5, 2014 at 2:56 PM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > On Monday 03 November 2014 11:05:26 Soren Brinkmann wrote:
> >> With the new 'groups' property, the DT parser can infer the map type
> >> from the fact whether 'pins' or 'groups' is used to specify the pin
> >> group to work on.
> >> To maintain backwards compatibitliy with current usage of the DT
> >> binding, this is only done when an invalid map type is passed to the
> >> parsing function.
> >
> > The Renesas PFC implements similar bindings with using the vendor-specific
> > properties "renesas,pins" and "renesas,groups" (bindings and implementation
> > available at Documentation/devicetree/bindings/pinctrl/renesas,pfc-pinctrl.txt
> > and drivers/pinctrl/sh-pfc/pinctrl.c respectively).
> >
> > The Renesas implementation is a bit more generic in that it allows both pins
> > and groups to be specified in a single subnode. Do you think that feature
> > would make sense for pinconf-generic as well ?
> 
> I think for generic pin controllers either nodes with:
> 
> {
>     function = "foo";
>     pins = "A0", "A1", "A2";
> }
> 
> or
> 
> {
>     function = "foo";
>     groups = "bar", "baz";
> }
> 
> In parsing this it's easy to just look for "function" then see if
> we're mapping to groups or pins.
> 
> It'd be nice if we could then centralize parsing of functions/pins/groups
> and add the non-renesas-prefixed configs as alternatives to genericized
> the bindings, while keeping backward compatibility.

I think the generic parser can't handle that currently. When it finds
'function' it passes the PINs to pinctrl_utils_add_map_mux(). That
function fails when it doesn't receive a group.
I don't know if the non-generic pinctrl drivers solve that somehow, but
pinconf-generic can't handle pins + function in the same node if we
change the meaning of pins to actually just be pins.

That is why I chose the "kludgy" approach. To maintain current behavior.
If nobody needs that though, things could change I guess.

	Sören
