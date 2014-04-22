Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbaDVPFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:05:13 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35865 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769AbaDVPFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:05:08 -0400
MIME-Version: 1.0
In-Reply-To: <1397680817-28470-1-git-send-email-abrestic@chromium.org>
References: <1397611505-17917-1-git-send-email-abrestic@chromium.org>
	<1397680817-28470-1-git-send-email-abrestic@chromium.org>
Date: Tue, 22 Apr 2014 17:05:07 +0200
Message-ID: <CACRpkdbLymoBxJrqdfpHLHDP9ytohqhhd1bdXevKnVS1mVPoNA@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: as3722: fix handling of GPIO invert bit
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 10:40 PM, Andrew Bresticker
<abrestic@chromium.org> wrote:

> The AS3722_GPIO_INV bit will always be blindly overwritten by
> as3722_pinctrl_gpio_set_direction() and will be ignored when
> setting the value of the GPIO in as3722_gpio_set() since the
> enable_gpio_invert flag is never set.  This will cause an
> initially inverted GPIO to toggle when requested as an output,
> which could be problematic if, for example, the GPIO controls
> a critical regulator.
>
> Instead of setting up the enable_gpio_invert flag, just leave
> the invert bit alone and check it before setting the GPIO value.
>
> Cc: <stable@vger.kernel.org> # v3.14+
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes from v1:
>  - fixed typo

This v2 version applied for fixes with Laxman's ACK.

Yours,
Linus Walleij
