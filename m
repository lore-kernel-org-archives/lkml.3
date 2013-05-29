Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935161Ab3E2Pgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:36:39 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56939 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743Ab3E2Pgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:36:37 -0400
MIME-Version: 1.0
In-Reply-To: <1369412476-14245-9-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
	<1369412476-14245-9-git-send-email-james.hogan@imgtec.com>
Date: Wed, 29 May 2013 17:36:36 +0200
Message-ID: <CACRpkda96Gwz7HFP5-KyiijRTafznwK+OKNxHFzk4j9pQ6A5ag@mail.gmail.com>
Subject: Re: [PATCH v2 8/9] pinctrl-tz1090-pdc: add TZ1090 PDC pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 6:21 PM, James Hogan <james.hogan@imgtec.com> wrote:

> +++ b/Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt

> +Optional subnode-properties:
> +- function: A string containing the name of the function to mux to the pin or
> +  group. Valid values for function names are listed below, including which
> +  pingroups can be muxed to them.
> +- tristate: Flag, put pin into high impedance state.
> +- pull-up: Flag, pull pin high.
> +- pull-down: Flag: pull pin low.
> +- bus-hold: Flag, weak latch last value on tristate bus.
> +- schmitt: Integer, enable or disable Schmitt trigger mode for the pins.
> +    0: no hysteresis
> +    1: schmitt trigger
> +- slew-rate: Integer, control slew rate of pins.
> +    0: slow (half frequency)
> +    1: fast
> +- drive-strength: Integer, control drive strength of pins in mA.
> +    2:  2mA
> +    4:  4mA
> +    8:  8mA
> +    12: 12mA
> +- power-on-start: Integer, power on start value of pins
> +    0: weak pull-down disabled
> +    1: weak pull-down for invalid power

Like on the first pinctrl patch, this needs to be genercized and moved to
the core, you're even adding code duplication between two drivers here,
so we really need to do something about it.

(...)
> +/* Describes pinconf properties/flags available from device tree */
> +static const struct cfg_param {
> +       const char *property;
> +       enum pin_config_param param;
> +       bool flag;
> +} cfg_params[] = {
> +       {"tristate",            PIN_CONFIG_BIAS_HIGH_IMPEDANCE,         true},
> +       {"pull-up",             PIN_CONFIG_BIAS_PULL_UP,                true},
> +       {"pull-down",           PIN_CONFIG_BIAS_PULL_DOWN,              true},
> +       {"bus-hold",            PIN_CONFIG_BIAS_BUS_HOLD,               true},
> +       {"power-on-start",      PIN_CONFIG_LOW_POWER_MODE,              true},
> +       {"schmitt",             PIN_CONFIG_INPUT_SCHMITT_ENABLE,        true},
> +       {"slew-rate",           PIN_CONFIG_SLEW_RATE,                   false},
> +       {"drive-strength",      PIN_CONFIG_DRIVE_STRENGTH,              false},
> +
> +};

Like this is looking very familiar.

Apart from that is it looking nice.

Yours,
Linus Walleij
