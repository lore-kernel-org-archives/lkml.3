Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932755AbaLDRVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:21:20 -0500
Received: from mail-by2on0063.outbound.protection.outlook.com ([207.46.100.63]:61439
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932164AbaLDRVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:21:18 -0500
Date: Thu, 4 Dec 2014 09:21:13 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-rockchip@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: Re: [PATCH v2 7/7] pinctrl: qcom-spmi-gpio: Migrate to
 pinconf-generic
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
 <1417137993-8337-8-git-send-email-soren.brinkmann@xilinx.com>
 <1417611812.30615.28.camel@mm-sol.com>
 <d3d1b263bf6242aa9a1a0876be455cce@BN1BFFO11FD021.protection.gbl>
 <1417685458.22963.1.camel@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417685458.22963.1.camel@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21150.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <81806c6b34a940c7a0378ed77c49b495@BN1AFFO11FD048.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(51704005)(24454002)(199003)(189002)(31966008)(92566001)(50466002)(33646002)(86362001)(46102003)(64706001)(108616004)(83506001)(50986999)(53416004)(230783001)(104016003)(99396003)(106466001)(77156002)(120916001)(4396001)(85202003)(74316001)(21056001)(6806004)(19580395003)(19580405001)(107046002)(54356999)(93886004)(62966003)(85182001)(20776003)(76176999)(47776003)(87936001)(23676002)(110136001)(92726002)(41533002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB014;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB014;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB014;
X-Forefront-PRVS: 041517DFAB
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB014;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 11:30AM +0200, Ivan T. Ivanov wrote:
> 
> On Wed, 2014-12-03 at 09:38 -0800, Sören Brinkmann wrote:
> > On Wed, 2014-12-03 at 03:03PM +0200, Ivan T. Ivanov wrote:
> > > On Thu, 2014-11-27 at 17:26 -0800, Soren Brinkmann wrote:
> > > > Instead of the driver caring about implementation details like device
> > > > tree, just provide information about driver specific pinconf parameters
> > > > to pinconf-generic which takes care of parsing the DT.
> > > > 
> > > > Signed-off-by: Soren Brinkmann brinkmann@xilinx.com>
> > > > ---
> > > > This is compile tested only. So, it's likely that it needs more tweaking
> > > > to make it actually work on HW. But it illustrates the potential
> > > > benefits of the pinconf-generic changes in this series.
> > > > ---
> > > >  drivers/pinctrl/qcom/pinctrl-spmi-gpio.c | 125 +++----------------------------
> > > >  1 file changed, 11 insertions(+), 114 deletions(-)
> > > > 
> > > > diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-
> > > > gpio.c
> > > > index b863b5080890..2db85e53ef73 100644
> > > > --- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
> > > > +++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
> > > > @@ -131,14 +131,14 @@ struct pmic_gpio_state {
> > > >         struct gpio_chip chip;
> > > >  };
> > > > 
> > > > -struct pmic_gpio_bindings {
> > > > -       const char*property;
> > > > -       unsigned      param;
> > > > +static const struct pinconf_generic_dt_params pmic_gpio_bindings[] = {
> > > > +       {"qcom,pull-up-strength",PMIC_GPIO_CONF_PULL_UP,0},
> > > > +       {"qcom,drive-strength",PMIC_GPIO_CONF_STRENGTH,0},
> > > >  };
> > > > 
> > > > -static struct pmic_gpio_bindings pmic_gpio_bindings[] = {
> > > > -       {"qcom,pull-up-strength",PMIC_GPIO_CONF_PULL_UP},
> > > > -       {"qcom,drive-strength",PMIC_GPIO_CONF_STRENGTH},
> > > > +static const struct pin_config_item pmic_conf_items[] = {
> > > > +       PCONFDUMP(PMIC_GPIO_CONF_PULL_UP,  "pull-up-strength", NULL, true),
> > > 
> > > s/pull-up-strength/qcom,pull-up-strength/
> > 
> > This is used for the debugfs output. I don't think you want the qcom
> > prefix here, do you?
> 
> Then at lest lets make it "pull up strength".

Ok. Will change it.

> 
> > 
> > > > +       PCONFDUMP(PMIC_GPIO_CONF_STRENGTH, "drive-strength", NULL, true),
> > > >  };
> > > > 
> > > 
> > > 
> > > 
> > > I am not happy that we have to define the same think two times.
> > 
> > It's not really the same thing. One is the actual DT binding the other
> > how the property is displayed in debugfs. Two different things. It's how
> > the core does it. That's not new.
> 
> This didn't make me more happy :-). Could both be merged?

That's definitely beyond the scope of this series.

	Soren
