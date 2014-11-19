Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbaKSPfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:35:48 -0500
Received: from mail-bn1on0064.outbound.protection.outlook.com ([157.56.110.64]:45899
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754735AbaKSPfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:35:46 -0500
Date: Wed, 19 Nov 2014 07:35:36 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 3/7] pinctrl: pinconf-generic: Allow driver to specify DT
 params
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
 <1415041531-15520-4-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdYfj2ydLQ4q_FKwXo73jzNsvj9u2Aem9EiuEw-OCvurrg@mail.gmail.com>
 <1416300621.30131.6.camel@mm-sol.com>
 <995406b8e0244c63a3ef8e58314e81f6@BL2FFO11FD037.protection.gbl>
 <1416383379.30131.14.camel@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416383379.30131.14.camel@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21116.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <84517404cda34124930ec838a639f538@BL2FFO11FD030.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(377454003)(51704005)(164054003)(51444003)(189002)(24454002)(199003)(87936001)(99396003)(120916001)(108616004)(93886004)(54356999)(76176999)(50986999)(74316001)(85182001)(77096003)(46102003)(21056001)(110136001)(77156002)(62966003)(4396001)(104016003)(50466002)(107046002)(85202003)(106466001)(31966008)(20776003)(95666004)(53416004)(19580405001)(86362001)(64706001)(47776003)(561944003)(102836001)(44976005)(83506001)(19580395003)(6806004)(92566001)(23676002)(41533002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB042;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB042;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB042;
X-Forefront-PRVS: 04004D94E2
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB042;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

On Wed, 2014-11-19 at 09:49AM +0200, Ivan T. Ivanov wrote:
> 
> On Tue, 2014-11-18 at 09:25 -0800, Sören Brinkmann wrote:
> > On Tue, 2014-11-18 at 10:50AM +0200, Ivan T. Ivanov wrote:
> > > 
> > > On Tue, 2014-11-11 at 15:53 +0100, Linus Walleij wrote:
> > > > On Mon, Nov 3, 2014 at 8:05 PM, Soren Brinkmann
> > > > brinkmann@xilinx.com> wrote:
> > > > 
> > > > > Additionally to the generic DT parameters, allow drivers to 
> > > > > provide driver-specific DT parameters to be used with the 
> > > > > generic parser infrastructure.
> > > > > 
> > > > > Signed-off-by: Soren Brinkmann brinkmann@xilinx.com>
> > > > 
> > > > I like the looks of this, but the patch description is a bit 
> > > > terse. I'd like it to describe some of the refactorings being 
> > > > done
> > > > to the intrinsics, because I have a hard time following the 
> > > > patch.
> > > > 
> > > > First please rebase onto the "devel" branch in the pin control 
> > > > tree, and notice that drivers/pinctrl/qcom/pinctrl-spmi-gpio.c 
> > > > which is merged there is actually doing this already:
> > > > 
> > > > 
> > > >         for_each_child_of_node(np_config, np) {
> > > >                 ret = pinconf_generic_dt_subnode_to_map(pctldev, 
> > > > np, map,
> > > >                                                         &reserv, 
> > > > nmaps, type);
> > > >                 if (ret)
> > > >                         break;
> > > > 
> > > >                 ret = pmic_gpio_dt_subnode_to_map(pctldev, np, 
> > > > map, &reserv,
> > > >                                                   nmaps, type);
> > > >                 if (ret)
> > > >                         break;
> > > >         }
> > > > 
> > > > So it should be patched to illustrate the point of this code.
> > > > 
> > > 
> > > I like the idea, but have issues with implementations :-).
> > >  
> > > It is supposed that additional parameters are not generic,
> > > otherwise they will be part of enum pin_config_param, right?
> > > 
> > > Probably it will be better if clients could pass array with
> > > driver specific dt bindings to pinconf_generic_dt_node_to_map()?
> > 
> > My idea was to hide that API from the driver. You just pass those 
> > parameters as part of the struct pctldev and the parser - whether 
> > this generic one or anything else - would do the right thing. I 
> > don't think calling the parser from the driver is the right approach.
> 
> Drivers already know about dt_node_to_map(). My proposal will make
> drivers, which register non-standard bindings, little bit simpler.

And I think this is not the best solution. Those drivers essentially
still do the DT parsing themselves, just call some common helpers. I
think that should be well separated. The pinctrl driver just assembles
some data structure that has the information regarding custom properties
and the core handles the rest. I find the approach I have in the zynq
driver - which does it that way - more elegant. The only reference to
the core parser there is the function pointer to the generic node to map
function. And even that could probably disappear in the long term when
everything migrates to using the core parser and generic bindings.

Also, why does it make the driver simpler? In my zynq driver I only have
those mentioned data structs and nothing in regards of parsing the DT.
With drivers calling the parser you duplicate exactly that all over the
place in each driver. More code, more duplication. And I don't see where
things become simpler. The core becomes a little more complex, but well,
that's why it gets consolidated there, right?

	Thanks,
	Sören
