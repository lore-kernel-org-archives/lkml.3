Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab3LNS5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 13:57:17 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:55317 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3LNS5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 13:57:15 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Alex Ling <kasimling@gmail.com>
Cc: rob.herring@calxeda.com, mark.rutland@arm.com, linux@arm.linux.org.uk,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: add board dts file for EXYNOS4412 based TINY4412 board
Date: Sat, 14 Dec 2013 19:57:06 +0100
Message-ID: <23915888.rvPOtSbknd@flatron>
User-Agent: KMail/4.11.4 (Linux/3.12.2-gentoo; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1384520969-2450-1-git-send-email-kasimling@gmail.com>
References: <1384520969-2450-1-git-send-email-kasimling@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Friday 15 of November 2013 21:09:29 Alex Ling wrote:
> Add a minimal board dts file for EXYNOS4412 based FriendlyARM's
> TINY4412 board. This patch including adds the node to support
> peripherals like UART, SD card on SDMMC2 port, and this patch
> adds GPIO connected LEDS and configure its properties like
> following:
> LED1: use 'heartbeat' trigger, blinking while the board is running.
> LED4: use 'mmc0' trigger, on when mmc0 is accessing.
> LED2 and LED3 can be controlled from userspace.

Well, all the LEDs can be controlled from userspace. The default trigger
is just the initial setting, which can be changed later by userspace.
It's just a general comment, not an issue with the patch, though.

Anyway, you don't need such detailed patch description, as you can see
most of the things directly from the code. In case of this patch, just the
list of supported peripherals is fine, without going into minor details,
such as LED triggers.

Also, please see my comments inline.

[snip]
> diff --git a/arch/arm/boot/dts/exynos4412-tiny4412.dts b/arch/arm/boot/dts/exynos4412-tiny4412.dts
> new file mode 100644
> index 0000000..78ace14
> --- /dev/null
> +++ b/arch/arm/boot/dts/exynos4412-tiny4412.dts
[snip]
> +	leds {
> +		compatible = "gpio-leds";

style: A blank line should be separating properties from nodes.

> +		led1 {
> +			label = "led1:heart";

Are the labels for this and the LEDs below related to the hardware?
I mean, the label should preferrably come from the board documentation,
or a label on the PCB next to the LED. Also they shouldn't represent
any particular use case, so you should remove the ":heart" suffix.

> +			gpios = <&gpm4 0 1>;
> +			default-state = "off";
> +			linux,default-trigger = "heartbeat";
> +		};

style: Subnodes should be separated with blank lines.

Otherwise the patch looks fine.

Best regards,
Tomasz

