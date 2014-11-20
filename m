Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbaKTQWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:22:30 -0500
Received: from mail-bn1on0086.outbound.protection.outlook.com ([157.56.110.86]:29504
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757785AbaKTQW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:22:27 -0500
Date: Thu, 20 Nov 2014 08:22:15 -0800
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
 <84517404cda34124930ec838a639f538@BL2FFO11FD030.protection.gbl>
 <1416470777.28873.1.camel@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416470777.28873.1.camel@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21118.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <7e2f4984733343fdb4ea51cf7eb4c339@BY2FFO11FD046.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(377454003)(199003)(51444003)(189002)(164054003)(51704005)(24454002)(50986999)(561944003)(4396001)(21056001)(76176999)(44976005)(54356999)(20776003)(64706001)(47776003)(92566001)(23676002)(31966008)(85182001)(87936001)(19580405001)(86362001)(19580395003)(83506001)(77096003)(107046002)(77156002)(93886004)(62966003)(74316001)(110136001)(6806004)(102836001)(99396003)(53416004)(50466002)(108616004)(95666004)(85202003)(104016003)(120916001)(46102003)(106466001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB028;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB028;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB028;
X-Forefront-PRVS: 0401647B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB028;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-20 at 10:06AM +0200, Ivan T. Ivanov wrote:
> 
> On Wed, 2014-11-19 at 07:35 -0800, Sören Brinkmann wrote:
> > Hi Ivan,
> > 
> > On Wed, 2014-11-19 at 09:49AM +0200, Ivan T. Ivanov wrote:
> > > On Tue, 2014-11-18 at 09:25 -0800, Sören Brinkmann wrote:
> > > > On Tue, 2014-11-18 at 10:50AM +0200, Ivan T. Ivanov wrote:
> > > > > On Tue, 2014-11-11 at 15:53 +0100, Linus Walleij wrote:
> > > > > > On Mon, Nov 3, 2014 at 8:05 PM, Soren Brinkmann
> > > > > > brinkmann@xilinx.com> wrote:
> > > > > > 
> > > > > > > Additionally to the generic DT parameters, allow drivers to
> > > > > > > provide driver-specific DT parameters to be used with the
> > > > > > > generic parser infrastructure.
> > > > > > > 
> > > > > > > Signed-off-by: Soren Brinkmann brinkmann@xilinx.com>
> > > > > > 
> > > > > > I like the looks of this, but the patch description is a bit
> > > > > > terse. I'd like it to describe some of the refactorings being
> > > > > > done
> > > > > > to the intrinsics, because I have a hard time following the
> > > > > > patch.
> > > > > > 
> > > > > > First please rebase onto the "devel" branch in the pin control
> > > > > > tree, and notice that drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
> > > > > > which is merged there is actually doing this already:
> > > > > > 
> > > > > > 
> > > > > >         for_each_child_of_node(np_config, np) {
> > > > > >                 ret = pinconf_generic_dt_subnode_to_map(pctldev,
> > > > > > np, map,
> > > > > >                                                         &reserv,
> > > > > > nmaps, type);
> > > > > >                 if (ret)
> > > > > >                         break;
> > > > > > 
> > > > > >                 ret = pmic_gpio_dt_subnode_to_map(pctldev, np,
> > > > > > map, &reserv,
> > > > > >                                                   nmaps, type);
> > > > > >                 if (ret)
> > > > > >                         break;
> > > > > >         }
> > > > > > 
> > > > > > So it should be patched to illustrate the point of this code.
> > > > > > 
> > > > > 
> > > > > I like the idea, but have issues with implementations :-).
> > > > > 
> > > > > It is supposed that additional parameters are not generic,
> > > > > otherwise they will be part of enum pin_config_param, right?
> > > > > 
> > > > > Probably it will be better if clients could pass array with
> > > > > driver specific dt bindings to pinconf_generic_dt_node_to_map()?
> > > > 
> > > > My idea was to hide that API from the driver. You just pass those
> > > > parameters as part of the struct pctldev and the parser - whether
> > > > this generic one or anything else - would do the right thing. I
> > > > don't think calling the parser from the driver is the right approach.
> > > 
> > > Drivers already know about dt_node_to_map(). My proposal will make
> > > drivers, which register non-standard bindings, little bit simpler.
> > 
> > And I think this is not the best solution. Those drivers essentially
> > still do the DT parsing themselves, 
> 
> Yes, and this could be avoided if there API which allow them to pass 
> non-standard configuration maps.
> 
> > just call some common helpers. I
> > think that should be well separated. 
> 
> Around 27 of 30 drivers are using custom dt_node_to_map(). And this is
> because most of them are using custom "x,pins", "x,functions" and 'x,groups"
> properties and I think that this is bigger issue, how this is addressed
> in this patch?

Not really in this patch, but Linus recently added the 'groups'
property. Somewhere in this thread he explained how he'd like to see
things used. With mux nodes that contain 'groups' and 'function' and
conf nodes that can contain 'groups' or 'pins' and the pinconf options.
And pins/groups would actually refer to only pins or groups
respectively.

Also, I hope all my changes here don't break the current behavior. So,
those 27 driver should still be able to do what they currently do. But I
hope they could migrated over to use the generic bindings only in the
longer term, so that these custom properties disappear.

> 
> > The pinctrl driver just assembles
> > some data structure that has the information regarding custom properties
> > and the core handles the rest. 
> 
> Yup, that is nice. What will be really nice if it also handle custom, 
> "function", "groups" and "pins" properties. Otherwise most of the drivers
> will not be able to benefit from this. 

Why would you still need those? I think the idea is to get rid of custom
pins, groups and function properties. Could you explain why those are
needed and why that couldn't be migrated to the amended bindings as outlined by
Linus, please?

	Thanks,
	Sören
