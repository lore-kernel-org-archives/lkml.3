Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaKLTjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 14:39:08 -0500
Received: from mail-by2on0058.outbound.protection.outlook.com ([207.46.100.58]:11936
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753151AbaKLTjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 14:39:06 -0500
X-Greylist: delayed 2720 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Nov 2014 14:39:06 EST
Date: Wed, 12 Nov 2014 11:38:58 -0800
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
Message-ID: <02ceb46374884cbeaf0335ac44b9ba45@BY2FFO11FD043.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(199003)(377424004)(377454003)(189002)(51704005)(44976005)(64706001)(23676002)(107046002)(31966008)(21056001)(4396001)(83506001)(20776003)(53416004)(47776003)(86362001)(106466001)(85182001)(19580405001)(110136001)(85202003)(102836001)(50986999)(76176999)(54356999)(108616004)(77156002)(120916001)(92566001)(50466002)(6806004)(62966003)(46102003)(87936001)(95666004)(104016003)(74316001)(99396003)(19580395003)(77096003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB042;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB042;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB042;
X-Forefront-PRVS: 03932714EB
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB042;
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

Just looking into this, one user besides those two drivers is
pinconf-generic: pinconf_generic_dt_node_to_map() which is called from
 pinconf_generic_dt_node_to_map_pin() and
 pinconf_generic_dt_node_to_map_group()

And those would be a couple of more users. That's why I chose to not
change the behavior since this adds another 4 drivers to the list of
users that might depend on certain behavior.

	Sören
