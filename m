Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935244Ab3FSWDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 18:03:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35550 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934979Ab3FSWDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 18:03:05 -0400
Message-ID: <51C22A95.4050703@wwwdotorg.org>
Date: Wed, 19 Jun 2013 16:03:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Hogan <james.hogan@imgtec.com>,
        Stephen Warren <swarren@nvidia.com>,
        =?UTF-8?B?77+9?= <heiko@sntech.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] pinctrl: establish pull-up/pull-down terminology
References: <1371379548-6482-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1371379548-6482-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2013 04:45 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> It is counter-intuitive to have "0" mean disable in a boolean
> manner for electronic properties of pins such as pull-up and
> pull-down. Therefore, define that a pull-up/pull-down argument
> of 0 to such a generic option means that the pin is
> short-circuited to VDD or GROUND. Pull disablement shall be
> done using PIN_CONFIG_BIAS_DISABLE.
> 
> Cc: Heiko St�bner <heiko@sntech.de>
> Cc: James Hogan <james.hogan@imgtec.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  include/linux/pinctrl/pinconf-generic.h | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/pinctrl/pinconf-generic.h b/include/linux/pinctrl/pinconf-generic.h
> index d414a77..67780f5 100644
> --- a/include/linux/pinctrl/pinconf-generic.h
> +++ b/include/linux/pinctrl/pinconf-generic.h
> @@ -36,14 +36,15 @@
>   *	tristate. The argument is ignored.
>   * @PIN_CONFIG_BIAS_PULL_UP: the pin will be pulled up (usually with high
>   *	impedance to VDD). If the argument is != 0 pull-up is enabled,
> - *	if it is 0, pull-up is disabled.
> + *	if it is 0, pull-up it total, i.e. the pin is connected to VDD.
>   * @PIN_CONFIG_BIAS_PULL_DOWN: the pin will be pulled down (usually with high
>   *	impedance to GROUND). If the argument is != 0 pull-down is enabled,
> - *	if it is 0, pull-down is disabled.
> + *	if it is 0, pull-down is total, i.e. the pin is connected to GROUND.
>   * @PIN_CONFIG_BIAS_PULL_PIN_DEFAULT: the pin will be pulled up or down based
>   *	on embedded knowledge of the controller, like current mux function.
> - *	If the argument is != 0 pull up/down is enabled, if it is 0,
> - *	the pull is disabled.
> + *	If the argument is != 0 pull up/down is enabled, if it is 0, the
> + *	configuration is ignored. The proper way to disable it is to use
> + *	@PIN_CONFIG_BIAS_DISABLE.

Why treat PULL_UP/PULL_DOWN differently from PULL_PIN_DEFAULT?
PULL_PIN_DEFAULT is logically simply a macro that selects PULL_UP/DOWN
based on what's "normal" for the pin's expected usage, so surely the
value associated with that option should behave identically?

