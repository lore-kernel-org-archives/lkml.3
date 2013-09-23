Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab3IWTZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:25:58 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:63652 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3IWTZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <1379320326-13241-10-git-send-email-treding@nvidia.com>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
	<1379320326-13241-10-git-send-email-treding@nvidia.com>
Date: Mon, 23 Sep 2013 21:25:53 +0200
Message-ID: <CACRpkdbLGThUTteqmEcfda7Tvc08ZFWwe=WpKMyxALQe=LZLVA@mail.gmail.com>
Subject: Re: [PATCH 9/9] gpio: tegra: Use module_platform_driver()
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 10:32 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> With the driver core now resolving interrupt references at probe time,
> it is no longer necessary to force explicit probe ordering using
> initcalls.
>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Note that there are potentially many more drivers that can be switched
> to the generic module_*_driver() interfaces now that interrupts can be
> resolved later and deferred probe should be able to handle all the
> ordering issues.

Let me see if I get this right: so this would be all GPIO/pinctrl
drivers which are probed exclusively from the device tree
so anything that depends explicitly on CONFIG_OF would
be a candidate?

I think we have a bit of a problem that some drivers depend
only on a certain arch or compiles directly for a certain arch
without any specific Kconfig option so that this may be a
bit hard to spot, so we should keep an eye out for this
once this probing scheme is in place.

Yours,
Linus Walleij
