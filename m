Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaKLSqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:46:38 -0500
Received: from mail-bn1bon0099.outbound.protection.outlook.com ([157.56.111.99]:9692
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753144AbaKLSqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:46:36 -0500
Date: Wed, 12 Nov 2014 10:46:26 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 2/7] pinctrl: pinconf-generic: Infer map type from DT
 property
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
 <1415041531-15520-3-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdbOLMT1vfFg=CAU_VHdjxPWn_Ybso=+8Asp=mXhmNBRSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbOLMT1vfFg=CAU_VHdjxPWn_Ybso=+8Asp=mXhmNBRSA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21096.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <ce4400ac9091437aa7da16ea131c65cd@BN1BFFO11FD005.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377454003)(189002)(377424004)(199003)(24454002)(51704005)(4396001)(6806004)(53416004)(110136001)(85182001)(31966008)(106466001)(74316001)(19580395003)(95666004)(44976005)(83506001)(85202003)(87936001)(19580405001)(54356999)(86362001)(92566001)(23676002)(120916001)(104016003)(107046002)(99396003)(77156002)(50466002)(76176999)(33646002)(46102003)(102836001)(50986999)(77096003)(108616004)(64706001)(21056001)(47776003)(20776003)(62966003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB048;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB048;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB048;
X-Forefront-PRVS: 03932714EB
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB048;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 01:47PM +0100, Linus Walleij wrote:
> On Mon, Nov 3, 2014 at 8:05 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > With the new 'groups' property, the DT parser can infer the map type
> > from the fact whether 'pins' or 'groups' is used to specify the pin
> > group to work on.
> > To maintain backwards compatibitliy with current usage of the DT
> > binding, this is only done when an invalid map type is passed to the
> > parsing function.
> 
> So that is this:
> 
> > +               if (type == PIN_MAP_TYPE_INVALID)
> > +                       type = PIN_MAP_TYPE_CONFIGS_GROUP;
> > +               dt_pin_specifier = "groups";
> 
> This is just kludgy. There are only two kernel-internal users of this function,
> refactor the function signature and change the other callers over instead,
> patch the drivers.

As I said in my other email. I chose to maintain current behavior to
avoid disturbing current users. If changing this the way you suggest,
works for everybody that is clearly preferred.

> 
> Take this opportunity to add some kerneldoc above the
> pinconf_generic_dt_subnode_to_map() and give the function a
> reasonable signature.

Yeah, didn't want to put too much effort into it without a confirmation
of this being on the right track.

> 
> BTW: this is just for config settings for groups right? Not for muxing
> I hope?

Yep, when 'function' is found, the pins/groups are passed to
pinctrl_utils_add_map_mux() which always uses mux group as type.

	Sören
