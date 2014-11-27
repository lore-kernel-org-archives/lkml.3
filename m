Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbaK0Rx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 12:53:26 -0500
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:31472
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750895AbaK0RxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 12:53:24 -0500
Date: Thu, 27 Nov 2014 09:53:14 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdYfj2ydLQ4q_FKwXo73jzNsvj9u2Aem9EiuEw-OCvurrg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21134.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <3656bd45ce11485ebe7dfa6b64ca87fe@BN1BFFO11FD023.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(24454002)(377424004)(199003)(377454003)(51704005)(19580395003)(104016003)(20776003)(108616004)(31966008)(44976005)(33646002)(6806004)(62966003)(86362001)(102836001)(76176999)(85182001)(54356999)(23676002)(74316001)(110136001)(50986999)(87936001)(92566001)(64706001)(99396003)(85202003)(95666004)(19580405001)(77096003)(106466001)(50466002)(83506001)(77156002)(47776003)(53416004)(46102003)(21056001)(107046002)(4396001)(120916001)(41533002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB058;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB058;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB058;
X-Forefront-PRVS: 040866B734
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB058;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, 2014-11-11 at 03:53PM +0100, Linus Walleij wrote:
> On Mon, Nov 3, 2014 at 8:05 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > Additionally to the generic DT parameters, allow drivers to provide
> > driver-specific DT parameters to be used with the generic parser
> > infrastructure.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> 
> I like the looks of this, but the patch description is a bit terse.
> I'd like it to describe some of the refactorings being done
> to the intrinsics, because I have a hard time following the patch.

I'll be a little more verbose :)

> 
> First please rebase onto the "devel" branch in the pin control
> tree, and notice that drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
> which is merged there is actually doing this already:
> 
> 
>         for_each_child_of_node(np_config, np) {
>                 ret = pinconf_generic_dt_subnode_to_map(pctldev, np, map,
>                                                         &reserv, nmaps, type);
>                 if (ret)
>                         break;
> 
>                 ret = pmic_gpio_dt_subnode_to_map(pctldev, np, map, &reserv,
>                                                   nmaps, type);
>                 if (ret)
>                         break;
>         }
> 
> So it should be patched to illustrate the point of this code.

I'll look into this.

> 
> I'd like feedback from Ivan+Björn on the code too if possible.
> 
> > -       ret = pinconf_generic_parse_dt_config(np, &configs, &nconfigs);
> > +       ret = pinconf_generic_parse_dt_config(np, pctldev, &configs, &nconfigs);
> >         if (nconfigs)
> >                 has_config = 1;
> >         np_config = of_parse_phandle(np, "ste,config", 0);
> >         if (np_config) {
> > -               ret = pinconf_generic_parse_dt_config(np_config, &configs,
> > -                               &nconfigs);
> > +               ret = pinconf_generic_parse_dt_config(np_config, pctldev,
> > +                               &configs, &nconfigs);
> 
> This code is patched upstream so that ABx500 only uses generic config.
> Again rebase on "devel"

Yeah, causes a conflict, but seems to be pretty much the same.

> 
> > -void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
> > -                             struct seq_file *s, unsigned pin)
> > +static void _pinconf_generic_dump(struct pinctrl_dev *pctldev,
> > +                                 struct seq_file *s, const char *gname,
> > +                                 unsigned pin,
> > +                                 const struct pin_config_item *items,
> > +                                 int nitems)
> 
> Don't use functions named _foo, actually the underscore is for
> preprocessor and compiler things in my book, just give it an intuitive
> name instead. Like pinconf_generic_dump_one() if that is suitable
> or whatever.
> 
> This changes the function signature from something quite intuitively
> understood to something pretty hard to understand, so you need to
> add kerneldoc to it. (That also enhance my understanding of the
> patch.)

I'll rename it and add some documentation.

> 
> > -void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
> > -                             struct seq_file *s, const char *gname)
> > +static void pinconf_generic_dump(struct pinctrl_dev *pctldev,
> > +                                struct seq_file *s, const char *gname,
> > +                                unsigned pin)
> 
> This looks intuitive and nice.
> 
> > +       _pinconf_generic_dump(pctldev, s, gname, pin,
> > +                             conf_items, ARRAY_SIZE(conf_items));
> > +       if (pctldev->desc->num_dt_params) {
> > +               BUG_ON(!pctldev->desc->conf_items);
> 
> Don't use BUG_ON() like that, it's nasty. Always try to
> recover and bail out instead.

I merge the condition into the if.

> 
> > +void pinconf_generic_dump_pin(struct pinctrl_dev *pctldev,
> > +                             struct seq_file *s, unsigned pin)
> > +{
> > +       pinconf_generic_dump(pctldev, s, NULL, pin);
> > +}
> > +
> > +void pinconf_generic_dump_group(struct pinctrl_dev *pctldev,
> > +                             struct seq_file *s, const char *gname)
> > +{
> > +       pinconf_generic_dump(pctldev, s, gname, 0);
> > +}
> 
> Do you really need these helpers? Isn't it simpler just
> to call the generic function with the different arguments?

I'll remove the helpers and patch the users of these functions.

> 
> > @@ -148,17 +132,22 @@ void pinconf_generic_dump_config(struct pinctrl_dev *pctldev,
> >                 seq_printf(s, "%s: 0x%x", conf_items[i].display,
> >                            pinconf_to_config_argument(config));
> >         }
> > +
> > +       if (!pctldev->desc->num_dt_params)
> > +               return;
> > +
> > +       BUG_ON(!pctldev->desc->conf_items);
> 
> No BUG_ON() dev_err() and exit.

As above.

> 
> > +static void _parse_dt_cfg(struct device_node *np,
> > +                         const struct pinconf_generic_dt_params *params,
> > +                         unsigned int count,
> > +                         unsigned long *cfg,
> > +                         unsigned int *ncfg)
> 
> Should return an error code right? Kerneldoc doesn't hurt either.

I don't see a need for an error return. It's currently not needed and
this refactoring doesn't change that, IMHO. I'll add kerneldoc.

> 
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < count; i++) {
> > +               u32 val;
> > +               int ret;
> > +               const struct pinconf_generic_dt_params *par = &params[i];
> > +
> > +               ret = of_property_read_u32(np, par->property, &val);
> 
> Not checking this return value. Alter the function to return an
> int value on success.

It's checked in the very next statement?! And it's all handled in this
function. No need to report anything to the caller.

> 
> > +
> > +               /* property not found */
> > +               if (ret == -EINVAL)
> > +                       continue;
> > +
> > +               /* use default value, when no value is specified */
> > +               if (ret)
> > +                       val = par->default_value;
> > +
> > +               pr_debug("found %s with value %u\n", par->property, val);
> > +               cfg[*ncfg] = pinconf_to_config_packed(par->param, val);
> > +               (*ncfg)++;
> > +       }
> > +}
> 
> There is something very unintuitive about this loop. You pass two
> counter indexes (count, ncfg) in basically, that is looking weird,
> does it have to look like that? Especially since there is no
> bounds check on ncfg!
> 
> Just use one index in the loop please. Assign  *ncfg = ... after
> the loop has *successfully* iterated.

I think this needs to be as is. There are two arrays @cfg and @params.
@params holding the DT params parsed with @count indicating the
boundary. And @cfg, where the parsed options are put with @ncfg being
a write pointer. @nfcg can be passed non-zero into this function. The
caller is responsible to allocate enough memory to hold all possible entries.

> 
> >  int pinconf_generic_parse_dt_config(struct device_node *np,
> > +                                   struct pinctrl_dev *pctldev,
> >                                     unsigned long **configs,
> >                                     unsigned int *nconfigs)
> 
> This is a good refactoring, but no _foo naming!

Will be renamed.

> 
> >  {
> >         unsigned long *cfg;
> > -       unsigned int ncfg = 0;
> > +       unsigned int max_cfg, ncfg = 0;
> >         int ret;
> > -       int i;
> > -       u32 val;
> >
> >         if (!np)
> >                 return -EINVAL;
> >
> >         /* allocate a temporary array big enough to hold one of each option */
> > -       cfg = kzalloc(sizeof(*cfg) * ARRAY_SIZE(dt_params), GFP_KERNEL);
> > +       max_cfg = ARRAY_SIZE(dt_params);
> > +       if (pctldev)
> > +               max_cfg += pctldev->desc->num_dt_params;
> > +       cfg = kcalloc(max_cfg, sizeof(*cfg), GFP_KERNEL);
> 
> Aha this looks good...
> 
> > +       _parse_dt_cfg(np, dt_params, ARRAY_SIZE(dt_params), cfg, &ncfg);
> > +       if (pctldev && pctldev->desc->num_dt_params) {
> > +               BUG_ON(!pctldev->desc->params);
> 
> No BUG_ON()

as above.

	Sören
