Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaFXGnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:43:31 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:50871 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaFXGn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:43:29 -0400
Message-ID: <53A91E09.7050603@gmail.com>
Date: Tue, 24 Jun 2014 12:13:21 +0530
From: Tushar Behera <trblinux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Kukjin Kim <kgene.kim@samsung.com>
CC: mark.rutland@arm.com, Tomasz Figa <tomasz.figa@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        ijc+devicetree@hellion.org.uk, devicetree@vger.kernel.org,
        khilman@linaro.org, pawel.moll@arm.com, swarren@wwwdotorg.org,
        tushar.b@samsung.com, olof@lixom.net, robh+dt@kernel.org,
        ben-linux@fluff.org, ch.naveen@samsung.com,
        linux-arm-kernel@lists.infradead.org, rahul.sharma@samsung.com,
        sjg@chromium.org, linux-kernel@vger.kernel.org, galak@codeaurora.org,
        ajaynumb@gmail.com, javier.martinez@collabora.co.uk
Subject: Re: [PATCH v2] ARM: dts: Add cros_ec to exynos5420-peach-pit and
 exynos5800-peach-pi
References: <1403556576-8038-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1403556576-8038-1-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 02:19 AM, Doug Anderson wrote:
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
> * Needs (spi: s3c64xx: fix broken "cs_gpios" usage in the driver) and
>   (spi: s3c64xx: for DT platofrms always get the chipselect info from
>   DT node) to work properly and match the documented bindings.  See
>   <https://patchwork.kernel.org/patch/4346701/> and
>   <https://patchwork.kernel.org/patch/4346711/>
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Along with the dependency patches on next-20140623, tested keyboard on
Peach-Pi board.

Tested-by: Tushar Behera <tushar.b@samsung.com>

Some comments below.

> ---
> Changes in v2:
> - Now just one patch since mfd patch landed.
> - Rebased to ToT linux-next
> 
>  arch/arm/boot/dts/exynos5420-peach-pit.dts | 145 +++++++++++++++++++++++++++++
>  arch/arm/boot/dts/exynos5800-peach-pi.dts  | 145 +++++++++++++++++++++++++++++
>  2 files changed, 290 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5420-peach-pit.dts b/arch/arm/boot/dts/exynos5420-peach-pit.dts
> index 7649982..581f385 100644
> --- a/arch/arm/boot/dts/exynos5420-peach-pit.dts
> +++ b/arch/arm/boot/dts/exynos5420-peach-pit.dts

> +				regulators {
> +					dcdc1 {
> +						ti,enable-ext-control;
> +					};
> +					dcdc2 {
> +						ti,enable-ext-control;
> +					};
> +					dcdc3 {
> +						ti,enable-ext-control;
> +					};
> +					fet1 {

"tps65090_fet1: fet1 {" ?

> +						regulator-name = "vcd_led";
> +					};
> +					tps65090_fet2: fet2 {

I would suggest we add similar labels to fet1, fet3, fet4, fet5 and fet6
also. That way it would be easy to reference them in subsequent DT nodes.

Same comment for Peach-Pi dts file too.

-- 
Tushar Behera
