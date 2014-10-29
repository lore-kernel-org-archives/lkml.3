Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaJ2BeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 21:34:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60626 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaJ2BeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 21:34:13 -0400
Message-ID: <54504407.3090700@wwwdotorg.org>
Date: Tue, 28 Oct 2014 19:33:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Matthias Klein <matthias.klein@linux.com>,
        linux-rpi-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1414457566-31802-1-git-send-email-matthias.klein@linux.com>
In-Reply-To: <1414457566-31802-1-git-send-email-matthias.klein@linux.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2014 06:52 PM, Matthias Klein wrote:
> The model B and B+ differ in the GPIO lines for ACT and PWR led.
> The PWR led on the B+ model is active low.

This new file is almost identical to bcm2835-rpi.dts. Perhaps we can use
some include files to share the common portions so they aren't
duplicated. Roughly:

* Move all the common content from bcm2835-rpi.dts into bcm2835-rpi.dtsi.

* Update bcm2835-rpi.dts to include bcm2835-rpi.dtsi to get all the
common parts, and add the few lines of differences.

* Update this patch similarly.

Does that make sense?

A couple changes to this patch and the existing bcm2835-rpi.dts might
reduce the differences even further, leading to more common code in
bcm2835-rpi.dtsi:

- Add the PWR LED to bcm2835-rpi-b.dts, if appropriate.
- Add the I2S pinmux settings for B+ too.

> diff --git a/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts b/arch/arm/boot/dts/bcm2835-rpi-b-plus.dts
...
> +&mmc {

That label doesn't exist; it should be &sdhci. Consequently:

> Error: arch/arm/boot/dts/bcm2835-rpi-b-plus.dts:64.2-3 label or path, 'mmc', not found
> FATAL ERROR: Syntax error parsing input tree
> make[1]: *** [arch/arm/boot/dts/bcm2835-rpi-b-plus.dtb] Error 1

This new DT file should be added to arch/arm/boot/dts/Makefile too.
