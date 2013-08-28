Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3H1M2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:28:05 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:55450 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3H1M2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:28:03 -0400
MIME-Version: 1.0
In-Reply-To: <1377380400-11331-1-git-send-email-b.brezillon@overkiz.com>
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com>
	<1377380400-11331-1-git-send-email-b.brezillon@overkiz.com>
Date: Wed, 28 Aug 2013 14:28:02 +0200
Message-ID: <CACRpkdbGWAg19Redc-KB4=dUnNOqCVvFN4H=wAAoki6Y=Zp-wA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] ARM: at91/dt: move sama5 to generic pinconf
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 11:40 PM, Boris BREZILLON
<b.brezillon@overkiz.com> wrote:

> Add generic pinconf definitions and reference appropriate configs in
> atmel,pins properties.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
(...)
>                         pinctrl@fffff200 {
>                                 #address-cells = <1>;
>                                 #size-cells = <1>;
> -                               compatible = "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "simple-bus";
> +                               compatible = "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "generic-pinconf", "simple-bus";

What kind of compatible string is that "generic-pinconf"?

There is no driver that can instantiate against this string but I'm not
100% sure about such things. Is there some other driver doing this?

Else I think it'd just be removed.

> +                               pcfg_none: pcfg_none {
> +                                       bias-disable;
> +                               };
> +
> +                               pcfg_pull_up: pcfg_pull_up {
> +                                       bias-pull-up;
> +                               };

Nice.

> +                               pcfg_deglitch: pcfg_deglitch {
> +                                       input-deglitch = <1>;
> +                               };
> +
> +                               pcfg_pull_up_deglitch: pcfg_pull_up_deglitch {
> +                                       bias-pull-up;
> +                                       input-deglitch = <1>;
> +                               };

input-deglitch seems like a proposed generic binding but I haven't seen
these yet?

(It might be in my violently exploding INBOX though sorry in that case.)

This would need adding to
Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
Plus changes to pinctrl core for handling.

BTW: this is really moving in the right direction!

Yours,
Linus Walleij
