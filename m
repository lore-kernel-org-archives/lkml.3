Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab3BGARM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:17:12 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35735 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465Ab3BGARL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:17:11 -0500
Message-ID: <5112F284.3040002@wwwdotorg.org>
Date: Wed, 06 Feb 2013 17:17:08 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        arm@kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 13/14] ARM: ux500: enable AB8500 GPIO for HREF
References: <1360093715-6348-1-git-send-email-linus.walleij@stericsson.com> <1360093715-6348-14-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1360093715-6348-14-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 12:48 PM, Linus Walleij wrote:
> From: Lee Jones <lee.jones@linaro.org>
> 
> The AB8500 GPIO driver has been un-BROKEN and rewritten as a pinctrl
> driver. Now that it's back in use, let's ensure that it's available
> when booting HREF with Device Tree enabled.

> diff --git a/arch/arm/boot/dts/hrefprev60.dts b/arch/arm/boot/dts/hrefprev60.dts

>  	soc-u9500 {
> +		prcmu@80157000 {
> +			ab8500@5 {
> +				ab8500-gpio {
> +					compatible = "stericsson,ab8500-gpio";

The MFDs I've looked at (which admittedly might not be that many) all
have the top-level chip described in device tree, but not all the
component sub-devices, since they're all a static part of the top-level
chip. Instead, the top-level MFD instantiates all the sub-devices
itself. I'm curious why this MFD device works differently - do many work
like this?
