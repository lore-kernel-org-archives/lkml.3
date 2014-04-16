Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422737AbaDPQVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:21:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60969 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422648AbaDPQVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:21:06 -0400
Message-ID: <534EADF0.1020907@wwwdotorg.org>
Date: Wed, 16 Apr 2014 10:21:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: as3722: fix handling of GPIO invert bit
References: <1397611505-17917-1-git-send-email-abrestic@chromium.org>
In-Reply-To: <1397611505-17917-1-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 07:25 PM, Andrew Bresticker wrote:
> The AS3722_GPIO_INV bit will always be blindly overwritten by
> as3722_pinctrl_gpio_set_direction() and will be ignored when
> setting the value of the GPIO in as3722_gpio_set() since the
> enable_gpio_invert flag is never set.  This will cause an
> initially inverted GPIO to toggle when requested as an output,
> which could be problematic if, for example, the GPIO controls
> a critical regulator.
> 
> Instead of setting up the enable_gpio_invert flag, uust leave
> the invert bit alone and check it before setting the GPIO value.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>

(not with a 'scope or anything, but an affected system boots in a stable
fashion with this applied)

Should this be CC: stable?
