Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3HLRiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:38:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51663 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3HLRix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:38:53 -0400
Message-ID: <52091DA9.7080200@wwwdotorg.org>
Date: Mon, 12 Aug 2013 11:38:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sonic Zhang <sonic.adi@gmail.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH v2] pinctrl: pinmux: Don't free pins requested by other
 devices in pinmux_disable_setting.
References: <1376287821-22980-1-git-send-email-sonic.adi@gmail.com>
In-Reply-To: <1376287821-22980-1-git-send-email-sonic.adi@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 12:10 AM, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> One peripheral may share part of its pins with the 2nd
> peripheral and the other pins with the 3rd. If it requests all pins
> when part of them has already be requested and owned by the 2nd
> peripheral, this request fails and pinmux_disable_setting() is called.
> The pinmux_disable_setting() frees all pins of the first peripheral
> without checking if the pin is owned by itself or the 2nd, which
> results in the malfunction of the 2nd peripheral driver.

This patch looks conceptually fine at a quick glance, but ...

> diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h

> @@ -154,6 +154,7 @@ struct pin_desc {
>  	const char *mux_owner;
>  	const struct pinctrl_setting_mux *mux_setting;
>  	const char *gpio_owner;
> +	const struct pinctrl_setting *owning_setting

... I think you can use the existing "mux_setting" field instead of
adding a new "owning_setting" field.
