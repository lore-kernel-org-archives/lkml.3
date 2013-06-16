Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab3FPK0k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 06:26:40 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:47227 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3FPK0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 06:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <201306141742.21808.heiko@sntech.de>
References: <201306141741.46077.heiko@sntech.de>
	<201306141742.21808.heiko@sntech.de>
Date: Sun, 16 Jun 2013 12:26:38 +0200
Message-ID: <CACRpkdaV78wXxGPFWVffEfnqrmhq1rsdVYdSKNx5mWaOcYOWrQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] pinctrl: update the documentation for some pinconfig params
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 5:42 PM, Heiko Stübner <heiko@sntech.de> wrote:

> The BIAS_DISABLE and BIAS_HIGH_IMPEDANCE generic pinconfig options were
> missing information about their argument - which should be ignored.
>
> Also the BIAS_PULL_* options may have the pull strength as argument
> when they are activated, while simpler hardware can use any
> non-0 value for it.
>
> Update the kerneldoc to reflect this.
>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

I'm holding this patch off.

>   * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
> - *     impedance to VDD). If the argument is != 0 pull-up is enabled,
> - *     if it is 0, pull-up is disabled.
> + *     impedance to VDD). If the argument is != 0 pull-up is enabled. On
> + *     hardware supporting this, the argument should contain the strength of
> + *     the pull in Ohm. If it is 0, pull-up is disabled.

As noted by Laurent, a pull-up of 0 Ohm is a short-circuit (bascially the TOTAL
pull-up) and it is pretty counter-intuitive to have that mean "disable pull-up".
Can we avoid this?

>   * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
> - *     impedance to GROUND). If the argument is != 0 pull-down is enabled,
> - *     if it is 0, pull-down is disabled.
> + *     impedance to GROUND). If the argument is != 0 pull-down is enabled. On
> + *     hardware supporting this, the argument should contain the strength of
> + *     the pull in Ohm. If it is 0, pull-down is disabled.

Dito.

>   * @PIN_CONFIG_BIAS_PULL_PIN_DEFAULT: the pin will be pulled up or down based
>   *     on embedded knowledge of the controller, like current mux function.
> - *     If the argument is != 0 pull up/down is enabled, if it is 0,
> - *     the pull is disabled.
> + *     If the argument is != 0 pull up/down is enabled. On hardware supporting
> + *     this, the argument should contain the strength of the pull in Ohm.
> + *     If it is 0, pull is disabled.

Dito.

Can't we rely on PIN_CONFIG_BIAS_DISABLE for all this?

Yours,
Linus Walleij
