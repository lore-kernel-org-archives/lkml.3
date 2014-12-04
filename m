Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaLDJae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:30:34 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:38847 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbaLDJac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:30:32 -0500
Message-ID: <1417685458.22963.1.camel@mm-sol.com>
Subject: Re: [PATCH v2 7/7] pinctrl: qcom-spmi-gpio: Migrate to
 pinconf-generic
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-rockchip@lists.infradead.org, linux-sh@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Date: Thu, 04 Dec 2014 11:30:58 +0200
In-Reply-To: <d3d1b263bf6242aa9a1a0876be455cce@BN1BFFO11FD021.protection.gbl>
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
	 <1417137993-8337-8-git-send-email-soren.brinkmann@xilinx.com>
	 <1417611812.30615.28.camel@mm-sol.com>
	 <d3d1b263bf6242aa9a1a0876be455cce@BN1BFFO11FD021.protection.gbl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.7-fta1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2014-12-03 at 09:38 -0800, Sören Brinkmann wrote:
> On Wed, 2014-12-03 at 03:03PM +0200, Ivan T. Ivanov wrote:
> > On Thu, 2014-11-27 at 17:26 -0800, Soren Brinkmann wrote:
> > > Instead of the driver caring about implementation details like device
> > > tree, just provide information about driver specific pinconf parameters
> > > to pinconf-generic which takes care of parsing the DT.
> > > 
> > > Signed-off-by: Soren Brinkmann brinkmann@xilinx.com>
> > > ---
> > > This is compile tested only. So, it's likely that it needs more tweaking
> > > to make it actually work on HW. But it illustrates the potential
> > > benefits of the pinconf-generic changes in this series.
> > > ---
> > >  drivers/pinctrl/qcom/pinctrl-spmi-gpio.c | 125 +++----------------------------
> > >  1 file changed, 11 insertions(+), 114 deletions(-)
> > > 
> > > diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-
> > > gpio.c
> > > index b863b5080890..2db85e53ef73 100644
> > > --- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
> > > +++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
> > > @@ -131,14 +131,14 @@ struct pmic_gpio_state {
> > >         struct gpio_chip chip;
> > >  };
> > > 
> > > -struct pmic_gpio_bindings {
> > > -       const char*property;
> > > -       unsigned      param;
> > > +static const struct pinconf_generic_dt_params pmic_gpio_bindings[] = {
> > > +       {"qcom,pull-up-strength",PMIC_GPIO_CONF_PULL_UP,0},
> > > +       {"qcom,drive-strength",PMIC_GPIO_CONF_STRENGTH,0},
> > >  };
> > > 
> > > -static struct pmic_gpio_bindings pmic_gpio_bindings[] = {
> > > -       {"qcom,pull-up-strength",PMIC_GPIO_CONF_PULL_UP},
> > > -       {"qcom,drive-strength",PMIC_GPIO_CONF_STRENGTH},
> > > +static const struct pin_config_item pmic_conf_items[] = {
> > > +       PCONFDUMP(PMIC_GPIO_CONF_PULL_UP,  "pull-up-strength", NULL, true),
> > 
> > s/pull-up-strength/qcom,pull-up-strength/
> 
> This is used for the debugfs output. I don't think you want the qcom
> prefix here, do you?

Then at lest lets make it "pull up strength".

> 
> > > +       PCONFDUMP(PMIC_GPIO_CONF_STRENGTH, "drive-strength", NULL, true),
> > >  };
> > > 
> > 
> > 
> > 
> > I am not happy that we have to define the same think two times.
> 
> It's not really the same thing. One is the actual DT binding the other
> how the property is displayed in debugfs. Two different things. It's how
> the core does it. That's not new.

This didn't make me more happy :-). Could both be merged?

Regards,
Ivan

