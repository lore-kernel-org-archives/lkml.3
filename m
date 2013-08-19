Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab3HSTUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:20:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56747 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab3HSTUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:20:13 -0400
Message-ID: <52126E06.1040108@wwwdotorg.org>
Date: Mon, 19 Aug 2013 13:12:06 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sherman Yin <syin@broadcom.com>
CC: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        matt.porter@linaro.org, csd@broadcom.com, mmayer@broadcom.com,
        james.hogan@imgtec.com
Subject: Re: [PATCH] pinctrl: Pass all configs to driver on pin_config_set()
References: <1376606573-15093-1-git-send-email-syin@broadcom.com>
In-Reply-To: <1376606573-15093-1-git-send-email-syin@broadcom.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2013 04:42 PM, Sherman Yin wrote:
> When setting pin configuration in the pinctrl framework, pin_config_set() or
> pin_config_group_set() is called in a loop to set one configuration at a time
> for the specified pin or group.
> 
> This patch 1) removes the loop and 2) changes the API to pass the whole pin
> config array to the driver.  It is now up to the driver to loop through the
> configs.  This allows the driver to potentially combine configs and reduce the
> number of writes to pin config registers.
> 
> Signed-off-by: Sherman Yin <syin@broadcom.com>
> Reviewed-by: Christian Daudt <csd@broadcom.com>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>

> Change-Id: I99cbfa2ae7b774456eb71edb276711b1ddcd42c8

That tag shouldn't be included in upstream patches.

>  drivers/pinctrl/pinconf.c             |   42 ++++----
>  drivers/pinctrl/pinctrl-tegra.c       |   69 ++++++------
>  include/linux/pinctrl/pinconf.h       |    6 +-

Those files, Reviewed-by: Stephen Warren <swarren@nvidia.com>

On Tegra (Tegra114 Dalmore board, on top of next-20130816),
Tested-by: Stephen Warren <nvidia.com>
