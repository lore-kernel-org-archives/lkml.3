Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab3FPKpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 06:45:35 -0400
Received: from gloria.sntech.de ([95.129.55.99]:55944 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148Ab3FPKpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 06:45:34 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/5] pinctrl: update the documentation for some pinconfig params
Date: Sun, 16 Jun 2013 12:45:29 +0200
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
References: <201306141741.46077.heiko@sntech.de> <201306141742.21808.heiko@sntech.de> <CACRpkdaV78wXxGPFWVffEfnqrmhq1rsdVYdSKNx5mWaOcYOWrQ@mail.gmail.com>
In-Reply-To: <CACRpkdaV78wXxGPFWVffEfnqrmhq1rsdVYdSKNx5mWaOcYOWrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306161245.30465.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 16. Juni 2013, 12:26:38 schrieb Linus Walleij:
> On Fri, Jun 14, 2013 at 5:42 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > The BIAS_DISABLE and BIAS_HIGH_IMPEDANCE generic pinconfig options were
> > missing information about their argument - which should be ignored.
> > 
> > Also the BIAS_PULL_* options may have the pull strength as argument
> > when they are activated, while simpler hardware can use any
> > non-0 value for it.
> > 
> > Update the kerneldoc to reflect this.
> > 
> > Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> 
> I'm holding this patch off.
> 
> >   * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with
> >   high
> > 
> > - *     impedance to VDD). If the argument is != 0 pull-up is enabled,
> > - *     if it is 0, pull-up is disabled.
> > + *     impedance to VDD). If the argument is != 0 pull-up is enabled. On
> > + *     hardware supporting this, the argument should contain the
> > strength of + *     the pull in Ohm. If it is 0, pull-up is disabled.
> 
> As noted by Laurent, a pull-up of 0 Ohm is a short-circuit (bascially the
> TOTAL pull-up) and it is pretty counter-intuitive to have that mean
> "disable pull-up". Can we avoid this?
> 
> >   * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with
> >   high
> > 
> > - *     impedance to GROUND). If the argument is != 0 pull-down is
> > enabled, - *     if it is 0, pull-down is disabled.
> > + *     impedance to GROUND). If the argument is != 0 pull-down is
> > enabled. On + *     hardware supporting this, the argument should
> > contain the strength of + *     the pull in Ohm. If it is 0, pull-down
> > is disabled.
> 
> Dito.
> 
> >   * @PIN_CONFIG_BIAS_PULL_PIN_DEFAULT: the pin will be pulled up or down
> >   based *     on embedded knowledge of the controller, like current mux
> >   function.
> > 
> > - *     If the argument is != 0 pull up/down is enabled, if it is 0,
> > - *     the pull is disabled.
> > + *     If the argument is != 0 pull up/down is enabled. On hardware
> > supporting + *     this, the argument should contain the strength of the
> > pull in Ohm. + *     If it is 0, pull is disabled.
> 
> Dito.
> 
> Can't we rely on PIN_CONFIG_BIAS_DISABLE for all this?

you're the boss on this, I'll do whatever you say :-)

I was going after the existing documentation of "bias-pull-X = <0>" being 
there to turn off this specific bias. So when reading the existing doc I was 
assuming somebody had needed this in the past.

Actually I'm too more comfortable with only using bias-disable.

So I'll redo this patch to remove the disabling of a pull via this method, if 
that's the right way to go.

Same with the rockchip driver.


Heiko
