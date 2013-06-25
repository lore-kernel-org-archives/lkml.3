Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab3FYNWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 09:22:00 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60572 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830Ab3FYNV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 09:21:59 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 3/4] pinctrl: remove slew-rate parameter from tz1090
Date: Tue, 25 Jun 2013 15:21:55 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
References: <201306251455.01540.heiko@sntech.de> <201306251456.36499.heiko@sntech.de> <51C99581.2010403@imgtec.com>
In-Reply-To: <51C99581.2010403@imgtec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201306251521.55634.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. Juni 2013, 15:05:05 schrieb James Hogan:
> Hi Heiko,
> 
> On 25/06/13 13:56, Heiko Stübner wrote:
> > As the binding for slew-rate is under discussion and seems to need
> > more tought it will get removed for now, so it doesn't get an offical
> 
> s/tought/thought/
> s/offical/official/
> 
> > release.
> > 
> > Therefore remove it again from the only current user, tz1090.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> > ---
> 
> <snip>
> 
> > diff --git a/drivers/pinctrl/pinctrl-tz1090-pdc.c
> > b/drivers/pinctrl/pinctrl-tz1090-pdc.c index 12e4808..d4f12cc 100644
> > --- a/drivers/pinctrl/pinctrl-tz1090-pdc.c
> > +++ b/drivers/pinctrl/pinctrl-tz1090-pdc.c
> > @@ -809,11 +809,6 @@ static int tz1090_pdc_pinconf_group_reg(struct
> > pinctrl_dev *pctldev,
> > 
> >  		*width = 1;
> >  		*map = tz1090_pdc_boolean_map;
> >  		break;
> > 
> > -	case PIN_CONFIG_SLEW_RATE:
> > -		*shift = REG_GPIO_CONTROL2_PDC_SR_S;
> > -		*width = 1;
> > -		*map = tz1090_pdc_boolean_map;
> > -		break;
> > 
> >  	case PIN_CONFIG_DRIVE_STRENGTH:
> >  		*shift = REG_GPIO_CONTROL2_PDC_DR_S;
> >  		*width = 2;
> > 
> > diff --git a/drivers/pinctrl/pinctrl-tz1090.c
> > b/drivers/pinctrl/pinctrl-tz1090.c index 02ff3a2..4edae08 100644
> > --- a/drivers/pinctrl/pinctrl-tz1090.c
> > +++ b/drivers/pinctrl/pinctrl-tz1090.c
> > @@ -1834,11 +1834,6 @@ static int tz1090_pinconf_group_reg(struct
> > pinctrl_dev *pctldev,
> > 
> >  		*width = 1;
> >  		*map = tz1090_boolean_map;
> >  		break;
> > 
> > -	case PIN_CONFIG_SLEW_RATE:
> > -		*reg = REG_PINCTRL_SR;
> > -		*width = 1;
> > -		*map = tz1090_boolean_map;
> > -		break;
> > 
> >  	case PIN_CONFIG_DRIVE_STRENGTH:
> >  		*reg = REG_PINCTRL_DR;
> >  		*width = 2;
> 
> I don't see the harm in keeping the handling of PIN_CONFIG_SLEW_RATE,
> since PIN_CONFIG_SLEW_RATE is still present and you only seem to be
> removing the device tree bindings (which is the only important bit from
> the DT ABI point of view).

I'm partial to this :-)

My thoughts were that this code would never be reached when the parsing was 
removed and to not cause confusion to the driver when an acceptable binding 
was found for slew-rate.

But it of course also doesn't hurt to stay in.


Heiko
