Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbbAMH5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:57:32 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33118 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbbAMH5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:57:30 -0500
MIME-Version: 1.0
In-Reply-To: <1417826408-1600-2-git-send-email-rjui@broadcom.com>
References: <rjui@broadcom.com>
	<1417826408-1600-1-git-send-email-rjui@broadcom.com>
	<1417826408-1600-2-git-send-email-rjui@broadcom.com>
Date: Tue, 13 Jan 2015 08:57:30 +0100
Message-ID: <CACRpkdaTU_efMOpKoEdBA0rDHyn6wcn7VamUZRiX-K2MYZygBQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] gpio: Cygnus: define Broadcom Cygnus GPIO binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Ray Jui <rjui@broadcom.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2014 at 1:40 AM, Ray Jui <rjui@broadcom.com> wrote:

> Document the GPIO device tree binding for Broadcom Cygnus SoC
>
> Signed-off-by: Ray Jui <rjui@broadcom.com>
> Reviewed-by: Scott Branden <sbranden@broadcom.com>
(...)
> +- #gpio-cells:
> +    Must be two. The first cell is the GPIO pin number (within the
> +controller's domain) and the second cell is used for the following:
> +    bit[0]: polarity (0 for normal and 1 for inverted)
> +    bit[18:16]: internal pull up/down: 0 - pull up/down disabled
> +                                       1 - pull up enabled
> +                                       2 - pull down enabled
> +    bit[22:20]: drive strength: 0 - 2 mA
> +                                1 - 4 mA
> +                                2 - 6 mA
> +                                3 - 8 mA
> +                                4 - 10 mA
> +                                5 - 12 mA
> +                                6 - 14 mA
> +                                7 - 16 mA

No. This pull up/down and drive strength is pin controller
business, use a pin control backend behind the GPIO driver
see Documentation/pinctrl.txt.

Initial states for these configurations can be set up using
pin control hogs since pin control and GPIO is orthogonal.

Yours,
Linus Walleij
