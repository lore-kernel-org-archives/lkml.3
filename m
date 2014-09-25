Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaIYNco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:32:44 -0400
Received: from cube.luon.net ([37.72.100.20]:53478 "EHLO cube.luon.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbaIYNcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:32:42 -0400
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Sep 2014 09:32:42 EDT
Date: Thu, 25 Sep 2014 15:27:17 +0200
From: Sjoerd Simons <sjoerd@luon.net>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Subject: Re: [5/5] ARM: tegra: jetson-tk1: enable GK20A GPU
Message-ID: <20140925132717.GA13579@dusk.luon.net>
References: <1400491450-19223-6-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400491450-19223-6-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Playing a bit with todays linux-next on my jetson, it seems this patch is
still required for enabling the GPU. Is there anything blocking it (firmware
not available yet in liux-firmware?)

On Mon, May 19, 2014 at 06:24:10PM +0900, Alexandre Courbot wrote:
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  arch/arm/boot/dts/tegra124-jetson-tk1.dts | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/tegra124-jetson-tk1.dts b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
> index e31fb61a81d3..15a194d1277f 100644
> --- a/arch/arm/boot/dts/tegra124-jetson-tk1.dts
> +++ b/arch/arm/boot/dts/tegra124-jetson-tk1.dts
> @@ -30,6 +30,12 @@
>  		};
>  	};
>  
> +	gpu@0,57000000 {
> +		status = "okay";
> +
> +		vdd-supply = <&vdd_gpu>;
> +	};
> +
>  	pinmux: pinmux@0,70000868 {
>  		pinctrl-names = "default";
>  		pinctrl-0 = <&state_default>;
> @@ -1505,7 +1511,7 @@
>  					regulator-always-on;
>  				};
>  
> -				sd6 {
> +				vdd_gpu: sd6 {
>  					regulator-name = "+VDD_GPU_AP";
>  					regulator-min-microvolt = <650000>;
>  					regulator-max-microvolt = <1200000>;

-- 
If you put it off long enough, it might go away.
