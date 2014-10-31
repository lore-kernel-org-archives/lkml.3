Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbaJaItm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:49:42 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34555 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaJaItg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:49:36 -0400
MIME-Version: 1.0
In-Reply-To: <1414529835-16207-1-git-send-email-dianders@chromium.org>
References: <1414529835-16207-1-git-send-email-dianders@chromium.org>
Date: Fri, 31 Oct 2014 09:49:35 +0100
Message-ID: <CACRpkdagHFAaPmQptsm7pz_JqYUCbU-0FoH45vrXo8pG6mTAxA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] pinctrl: Add output-disable
From: Linus Walleij <linus.walleij@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Sonny Rao <sonnyrao@chromium.org>,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, Sherman Yin <syin@broadcom.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 9:57 PM, Doug Anderson <dianders@chromium.org> wrote:
> The pinctrl bindings / API allow you to specify that:
> - a pin should be an output
> - a pin should have its input path enabled / disabled
>
> ...but they don't allow you to tell a pin to stop outputting.  Lets
> add a new setting for that just in case the bootloader (or the default
> state) left a pin as an output and we don't want it that way anymore.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
(...)
> + * @PIN_CONFIG_OUTPUT_DISABLE: this will configure the pin _not_ to output.
> + *     Parameter should be 1.

This doesn't make sense. The pin is either low, high, some analog mode
or tristate/high impedance.

It does *not* stop existing.

Figure out the exact electronic meaning of what happens when you do
"output disable" in your hardware, I think it is very likely that
PIN_CONFIG_BIAS_HIGH_IMPEDANCE is what you are really
after here.

Yours,
Linus Walleij
