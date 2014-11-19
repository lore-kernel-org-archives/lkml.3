Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbaKSHtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 02:49:21 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:55730 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbaKSHtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 02:49:19 -0500
Message-ID: <1416383379.30131.14.camel@mm-sol.com>
Subject: Re: [PATCH 3/7] pinctrl: pinconf-generic: Allow driver to specify
 DT params
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Date: Wed, 19 Nov 2014 09:49:39 +0200
In-Reply-To: <995406b8e0244c63a3ef8e58314e81f6@BL2FFO11FD037.protection.gbl>
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
	 <1415041531-15520-4-git-send-email-soren.brinkmann@xilinx.com>
	 <CACRpkdYfj2ydLQ4q_FKwXo73jzNsvj9u2Aem9EiuEw-OCvurrg@mail.gmail.com>
	 <1416300621.30131.6.camel@mm-sol.com>
	 <995406b8e0244c63a3ef8e58314e81f6@BL2FFO11FD037.protection.gbl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.7-fta1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-11-18 at 09:25 -0800, Sören Brinkmann wrote:
> On Tue, 2014-11-18 at 10:50AM +0200, Ivan T. Ivanov wrote:
> > 
> > On Tue, 2014-11-11 at 15:53 +0100, Linus Walleij wrote:
> > > On Mon, Nov 3, 2014 at 8:05 PM, Soren Brinkmann
> > > brinkmann@xilinx.com> wrote:
> > > 
> > > > Additionally to the generic DT parameters, allow drivers to 
> > > > provide driver-specific DT parameters to be used with the 
> > > > generic parser infrastructure.
> > > > 
> > > > Signed-off-by: Soren Brinkmann brinkmann@xilinx.com>
> > > 
> > > I like the looks of this, but the patch description is a bit 
> > > terse. I'd like it to describe some of the refactorings being 
> > > done
> > > to the intrinsics, because I have a hard time following the 
> > > patch.
> > > 
> > > First please rebase onto the "devel" branch in the pin control 
> > > tree, and notice that drivers/pinctrl/qcom/pinctrl-spmi-gpio.c 
> > > which is merged there is actually doing this already:
> > > 
> > > 
> > >         for_each_child_of_node(np_config, np) {
> > >                 ret = pinconf_generic_dt_subnode_to_map(pctldev, 
> > > np, map,
> > >                                                         &reserv, 
> > > nmaps, type);
> > >                 if (ret)
> > >                         break;
> > > 
> > >                 ret = pmic_gpio_dt_subnode_to_map(pctldev, np, 
> > > map, &reserv,
> > >                                                   nmaps, type);
> > >                 if (ret)
> > >                         break;
> > >         }
> > > 
> > > So it should be patched to illustrate the point of this code.
> > > 
> > 
> > I like the idea, but have issues with implementations :-).
> >  
> > It is supposed that additional parameters are not generic,
> > otherwise they will be part of enum pin_config_param, right?
> > 
> > Probably it will be better if clients could pass array with
> > driver specific dt bindings to pinconf_generic_dt_node_to_map()?
> 
> My idea was to hide that API from the driver. You just pass those 
> parameters as part of the struct pctldev and the parser - whether 
> this generic one or anything else - would do the right thing. I 
> don't think calling the parser from the driver is the right approach.

Drivers already know about dt_node_to_map(). My proposal will make
drivers, which register non-standard bindings, little bit simpler.

With your approach probably we can remove dt_node_to_map() and
dt_free_map() callbacks?

Regards,
Ivan


