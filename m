Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3LLUhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:37:43 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:61901 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3LLUhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:37:37 -0500
MIME-Version: 1.0
In-Reply-To: <1386787041-6035-5-git-send-email-syin@broadcom.com>
References: <1381174108-25168-1-git-send-email-syin@broadcom.com>
	<1386787041-6035-1-git-send-email-syin@broadcom.com>
	<1386787041-6035-5-git-send-email-syin@broadcom.com>
Date: Thu, 12 Dec 2013 21:37:36 +0100
Message-ID: <CACRpkdY7s+eUFkg0AsaN5B9-1y_mTJ29Y-D9CkRG2GQ3JshP+w@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] pinctrl: Add pinctrl binding for Broadcom Capri SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Sherman Yin <syin@broadcom.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 7:37 PM, Sherman Yin <syin@broadcom.com> wrote:

> Adds pinctrl driver devicetree binding for Broadcom Capri (BCM281xx) SoCs.
>
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> Reviewed-by: Christian Daudt <bcm@fixthebug.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> ---
> v3: Use generic pin config properties instead of brcm-specific ones.  Clarified
>     pin types (standard, i2c, hdmi).
> v2: Use hyphens instead of underscore in DT property names.

Overall this is very nice!

> +- bias-pull-up:                        Integer. Pull up strength in Ohm:
> +                                       1: 1.2 kOhm
> +                                       2: 1.8 kOhm
> +                                       3: 720 Ohm
> +                                       4: 2.7 kOhm
> +                                       5: 831 Ohm
> +                                       6: 1.08 kOhm
> +                                       7: 568 Ohm

Please do not use these custom enumerators 1 thru 7.
Instead say that the argument is given in ohms, so for
example:

bias-pull-up = <12000>;

Then translate this into the proper enumerator in your
driver instead.

No full example provided in the binding! This needs to
be there for understanding.

Yours,
Linus Walleij
