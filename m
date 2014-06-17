Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965653AbaFQQhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:37:14 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:55388 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964788AbaFQQhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:37:10 -0400
Message-ID: <53A06EB0.909@collabora.co.uk>
Date: Tue, 17 Jun 2014 18:37:04 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
CC: Tomasz Figa <tomasz.figa@gmail.com>, broonie@kernel.org, sjg@chromium.org,
        olof@lixom.net, ch.naveen@samsung.com, swarren@wwwdotorg.org,
        khilman@linaro.org, ajaynumb@gmail.com, rahul.sharma@samsung.com,
        tushar.b@samsung.com, linux-samsung-soc@vger.kernel.org,
        ben-linux@fluff.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: Add cros_ec to exynos5420-peach-pit and
 exynos5800-peach-pi
References: <1402683213-23120-1-git-send-email-dianders@chromium.org> <1402683213-23120-2-git-send-email-dianders@chromium.org>
In-Reply-To: <1402683213-23120-2-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 08:13 PM, Doug Anderson wrote:
> This adds cros_ec to exynos5420-peach-pit and exynos5800-peach-pi,
> including:
> * The keyboard
> * The i2c tunnel
> * The tps65090 under the i2c tunnel
> * The battery under the i2c tunnel
> 
> To add extra motivation, it should be noted that tps65090 is one of
> the things needed to get display-related FETs turned on for pit and
> pi.
> 
> Note that this relies on a few outstanding changes:
> * Needs "cros-ec-keyboard.dtsi" in order to compile properly.  See
>   (ARM: dts: Create a cros-ec-keyboard fragment) at
>   <https://patchwork.kernel.org/patch/4297451/>.
> * Needs (mfd: cros_ec: spi: Fix end of transfer on devices with no
>   spi-msg-delay) from this series to work properly.
> * Needs (spi: s3c64xx: fix broken "cs_gpios" usage in the driver) and
>   (spi: s3c64xx: for DT platofrms always get the chipselect info from
>   DT node) to work properly and match the documented bindings.  See
>   <https://patchwork.kernel.org/patch/4346701/> and
>   <https://patchwork.kernel.org/patch/4346711/>
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  arch/arm/boot/dts/exynos5420-peach-pit.dts | 146 +++++++++++++++++++++++++++++
>  arch/arm/boot/dts/exynos5800-peach-pi.dts  | 146 +++++++++++++++++++++++++++++
>  2 files changed, 292 insertions(+)
> 

After applying all the dependencies and this patch, I see that cros-ec-spi
driver is probed and also the keyboard is working on my Peach pit when testing
with: $ evtest /dev/input/event0

Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
