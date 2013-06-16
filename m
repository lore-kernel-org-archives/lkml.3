Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab3FPLCg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 07:02:36 -0400
Received: from gloria.sntech.de ([95.129.55.99]:56222 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab3FPLCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 07:02:35 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 5/5] pinctrl: rockchip: correctly handle arguments of pinconf options
Date: Sun, 16 Jun 2013 13:02:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201306141741.46077.heiko@sntech.de> <201306141744.21117.heiko@sntech.de> <CACRpkdY6pmS=5rphvYdt_8yKYJq8ADu0omy48ncZ3LFtEUf7yg@mail.gmail.com>
In-Reply-To: <CACRpkdY6pmS=5rphvYdt_8yKYJq8ADu0omy48ncZ3LFtEUf7yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306161302.32156.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 16. Juni 2013, 12:35:43 schrieb Linus Walleij:
> On Fri, Jun 14, 2013 at 5:44 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > Change the rockchip pinctrl driver to handle the arguments of 0 or 1 to
> > the pull pinconfig options correctly, so that the pull gets disabled when
> > either the bias_disable options is set or the pull option has the
> > argument 0.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> Patch applied so we can move ahead but:
> >         case PIN_CONFIG_BIAS_PULL_UP:
> >         case PIN_CONFIG_BIAS_PULL_DOWN:
> > 
> >         case PIN_CONFIG_BIAS_PULL_PIN_DEFAULT:
> > +               if (!rockchip_pinconf_pull_valid(info->ctrl, param))
> > +                       return -ENOTSUPP;
> > +
> > +               if (!arg)
> > +                       param = PIN_CONFIG_BIAS_DISABLE;
> 
> This is what I think is counter-intuitive.
> 
> Can't you rely on the bias-disable here instead?
> 
> > -               *config = 0;
> > +               pull = rockchip_get_pull(bank, pin - bank->pin_base);
> > +               *config = (pull == param) ? 1 : 0;
> 
> And then I guess you should emit PIN_CONFIG_BIAS_DISABLE
> here as well.

rockchip_get_pull does emit PIN_CONFIG_BIAS_DISABLE when the pull is disabled, 
only wrongly does add the argument here.


But I'm actually not quite sure what the expected behaviour is here at all :-)

Say the pin is in the "pin-default" pull state and the query in config_get is 
for "bias-disable", what would be the expected bahviour/return value in this 
case?


Thanks
Heiko
