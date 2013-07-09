Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab3GIQ5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 12:57:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52437 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3GIQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 12:57:39 -0400
Message-ID: <51DC4100.4050309@wwwdotorg.org>
Date: Tue, 09 Jul 2013 10:57:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: enable palmas device for dalmore
References: <1373290688-2257-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1373290688-2257-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 07:38 AM, Laxman Dewangan wrote:
> Make the entry of Dalmore Power Management Unit device TPS65913
> in dalmore DTS file. The Palma driver support this device.
> 
> Enable following submodule of the TPS65913:
> - GPIO driver
> - RTC driver.
> - Power regulator driver.

> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts

> +		palmas: tps65913@58 {

I assume there's only one TPS65913 in the system, so that node name
doesn't need to contain the unit address to make it unique; the node can
simply be named "tps65913".

> +			palmas_gpio: palmas_gpio {
> +			palmas_rtc {
> +			palmas_pmic {

I don't think those node names need "palmas" in them; they can simply be
"gpio", "rtc", "pmic".


> +			    ldousb-in-supply = <&tps65090_dcdc1_reg>;
> +			    regulators {

You'd usually leave a blank line between properties and nodes.

> +		vdd_cam_1v8_reg: regulator@6 {
...
> +			gpio = <&palmas_gpio 6 0>; /* Palmas GPIO6 */

That comment probably isn't worthwhile; I only insisted on them for
Tegra GPIOs so that the GPIO name could be included somewhere, whereas
for devices with just a small handful of GPIOs without any other names,
there's no point putting a comment, since it's obvious from the cell
content.
