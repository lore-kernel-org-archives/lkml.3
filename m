Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681Ab3CSUEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:04:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59594 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757266Ab3CSUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:03:58 -0400
Message-ID: <5148C4AB.1070502@wwwdotorg.org>
Date: Tue, 19 Mar 2013 14:03:55 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 5/7] usb: phy: tegra: get ULPI reset GPIO info using DT.
References: <1363609781-4045-1-git-send-email-vbyravarasu@nvidia.com> <1363609781-4045-6-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1363609781-4045-6-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 06:29 AM, Venu Byravarasu wrote:
> As GPIO information is avail through DT, used it to get Tegra ULPI
> reset GPIO number. Added a new member to tegra_usb_phy structure to
> store this number.

> diff --git a/drivers/usb/phy/tegra_usb_phy.c b/drivers/usb/phy/tegra_usb_phy.c

> -	gpio_direction_output(config->reset_gpio, 0);
> +	gpio_direction_output(phy->reset_gpio, 0);
>  	msleep(5);
> -	gpio_direction_output(config->reset_gpio, 1);
> +	gpio_direction_output(phy->reset_gpio, 1);

That implies that the PHY reset signal is active-low. This should be
represented in the GPIO flags in the device tree. In other words,
instead of e.g.:

nvidia,phy-reset-gpio = <&gpio 169 0>; /* gpio PV1 */

you want:

nvidia,phy-reset-gpio = <&gpio 169 1>; /* gpio PV1 */

Flag 1 means active-low. See
Documentation/devicetree/bindings/gpio/nvidia,tegra20-gpio.txt. This is
a bug in the current device tree content, although it has no effect
since no code currently uses the GPIO flags from DT. I suggest creating
a separate patch to fix this, and inserting it between patch 1 and 2 of
the series.
