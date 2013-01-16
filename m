Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3APL3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 06:29:10 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2272 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab3APL3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 06:29:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 16 Jan 2013 03:28:53 -0800
Date: Wed, 16 Jan 2013 13:28:56 +0200
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 5/9] ARM: Tegra: Define Tegra30 CAR binding
Message-ID: <20130116132856.2896df94f553f78273c4574c@nvidia.com>
In-Reply-To: <1357890387-23245-6-git-send-email-pgaikwad@nvidia.com>
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com>
	<1357890387-23245-6-git-send-email-pgaikwad@nvidia.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013 08:46:23 +0100
Prashant Gaikwad <pgaikwad@nvidia.com> wrote:

> The device tree binding models Tegra30 CAR (Clock And Reset)
> as a single monolithic clock provider.
> 
> Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
> ---
>  .../bindings/clock/nvidia,tegra30-car.txt          |  262 ++++++++++++++++++++
>  arch/arm/boot/dts/tegra30.dtsi                     |    6 +
>  2 files changed, 268 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
> 
> diff --git a/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt b/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
> new file mode 100644
> index 0000000..121d203
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/nvidia,tegra30-car.txt
> @@ -0,0 +1,262 @@
> +NVIDIA Tegra30 Clock And Reset Controller
> +
> +This binding uses the common clock binding:
......
> +  215  cml0
> +  216  cml1
> +  217  hclk
> +  218  pclk
> +
> +Example SoC include file:
> +
> +/ {
> +       tegra_car: clock {
> +               compatible = "nvidia,tegra30-car";
> +               reg = <0x60006000 0x1000>;
> +               #clock-cells = <1>;
> +       };
> +
> +       usb@c5004000 {
> +               clocks = <&tegra_car 58>; /* usb2 */
> +       };
> +};
> +
> +Example board file:
> +
> +/ {
> +       clocks {
> +               compatible = "simple-bug";

typo, 's/simple-bug/simple-bus/' ?
