Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab3BKVgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:36:24 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:36647 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759989Ab3BKVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:36:22 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V4 3/4] input: keyboard: tegra: add support for rows/cols configuration from dt
To: Laxman Dewangan <ldewangan@nvidia.com>, dmitry.torokhov@gmail.com
Cc: rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
In-Reply-To: <1357470900-12619-4-git-send-email-ldewangan@nvidia.com>
References: <1357470900-12619-1-git-send-email-ldewangan@nvidia.com> <1357470900-12619-4-git-send-email-ldewangan@nvidia.com>
Date: Mon, 11 Feb 2013 21:36:16 +0000
Message-Id: <20130211213616.862453E3530@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2013 16:44:59 +0530, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> The NVIDIA's Tegra KBC has maximum 24 pins to make matrix keypad.
> Any pin can be configured as row or column. The maximum column pin
> can be 8 and maximum row pin can be 16.
> 
> Remove the assumption that all first 16 pins will be used as row
> and remaining as columns and Add the property for configuring pins
> to either row or column from DT. Update the devicetree binding
> document accordingly.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - renames the rows and pins property array.
> - nit cleanups.
> Changes from V2/V3:
>  None
> 
>  .../bindings/input/nvidia,tegra20-kbc.txt          |   22 ++++++
>  drivers/input/keyboard/tegra-kbc.c                 |   74 +++++++++++++++-----
>  2 files changed, 79 insertions(+), 17 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/input/nvidia,tegra20-kbc.txt b/Documentation/devicetree/bindings/input/nvidia,tegra20-kbc.txt
> index 72683be..2995fae 100644
> --- a/Documentation/devicetree/bindings/input/nvidia,tegra20-kbc.txt
> +++ b/Documentation/devicetree/bindings/input/nvidia,tegra20-kbc.txt
> @@ -1,7 +1,18 @@
>  * Tegra keyboard controller
> +The key controller has maximum 24 pins to make matrix keypad. Any pin
> +can be configured as row or column. The maximum column pin can be 8
> +and maximum row pins can be 16 for Tegra20/Tegra30.
>  
>  Required properties:
>  - compatible: "nvidia,tegra20-kbc"
> +- reg: Register base address of KBC.
> +- interrupts: Interrupt number for the KBC.
> +- nvidia,kbc-row-pins: The KBC pins which are configured as row. This is an
> +  array of pin numbers which is used as rows.
> +- nvidia,kbc-col-pins: The KBC pins which are configured as column. This is an
> +  array of pin numbers which is used as column.
> +- linux,keymap: The keymap for keys as described in the binding document
> +  devicetree/bindings/input/matrix-keymap.txt.

For the binding:
Acked-by: Grant Likely <grant.likely@secretlab.ca>
