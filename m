Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935164Ab3FSV6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:58:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43188 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934858Ab3FSV6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:58:32 -0400
Message-ID: <51C22985.50106@wwwdotorg.org>
Date: Wed, 19 Jun 2013 15:58:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@linaro.org>,
        James Hogan <james.hogan@imgtec.com>, linux-sh@vger.kernel.org
Subject: Re: [RFC] pinctrl: generic: Add DT bindings
References: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 04:03 PM, Laurent Pinchart wrote:
> Document DT properties for the generic pinctrl parameters and add a
> parser function.

> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

> +== Generic pinconf parameters ==
> +
> +Pin configuration parameters are expressed by DT properties in the pin
> +controller device state nodes and child nodes. For devices that use the generic
> +pinconf parameters the following properties are defined.
> +
> +- tristate: A boolean, put the pin into high impedance state when set.

I don't think that a Boolean is appropriate here; it's really a tri-state:

* Nothing is specified about the tristate value; don't touch that aspect
of HW.
* Turn tristate on.
* Turn tristate off.

This can be a meaningful distinction when relying on e.g. the bootloader
having already set up the appropriate tristate value, or when
dynamically switching between different pinctrl states and not wanting
to affect tristate, or when piecing together multiple DT nodes that
describe part of a state, where one node covers just muxing and the
other just pin config (e.g. where the mux and pin config configuration
registers in HW affect different overlapping groups).

> +- schmitt: An integer, enable or disable Schmitt trigger mode for the pins.
> +  Valid values are
> +    0: Schmitt trigger disabled (no hysteresis)
> +    1: Schmitt trigger enabled

A similar comment applies here.

> +- slew-rate: An integer controlling the pin slew rate. Values are device-
> +  dependent.
> +
> +- drive-strength: An integer representing the drive strength of pins in mA.
> +  Valid values are device-dependent.

I'm still not convinced that requiring this to be in mA is a good idea.
Different HW will use different units for documentation, or even specify
no units at all, so it might not always be possible to represent this in
terms of mA. Asking for the documentation to be re-written simply to
support the DT binding just isn't going to happen.

