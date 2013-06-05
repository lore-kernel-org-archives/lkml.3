Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab3FERWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:22:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42075 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3FERWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:22:53 -0400
Message-ID: <51AF73E9.90506@wwwdotorg.org>
Date: Wed, 05 Jun 2013 11:22:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 1/3] drivers: pinctrl sleep and idle states in the core
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 07:44 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> If a device have sleep and idle states in addition to the
> default state, look up these in the core and stash them in
> the pinctrl state container.
> 
> Add accessor functions for pinctrl consumers to put the pins
> into "default", "sleep" and "idle" states passing nothing but
> the struct device * affected.
> 
> Solution suggested by Kevin Hilman, Mark Brown and Dmitry
> Torokhov in response to a patch series from Hebbar
> Gururaja.

> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c

> +int pinctrl_pm_select_default_state(struct device *dev)

> +int pinctrl_pm_select_sleep_state(struct device *dev)

> +int pinctrl_pm_select_idle_state(struct device *dev)

The implementation of those 3 functions is basically identical. I'd be
inclined to move it to a helper function, and just pass (dev,
pins->xxx_state) to it.
