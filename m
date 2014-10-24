Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaJXAsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 20:48:18 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52931 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaJXAsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 20:48:16 -0400
Date: Thu, 23 Oct 2014 17:48:11 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v13 3/5] ARM: dts: add RK3288 Thermal data
Message-ID: <20141024004811.GE9463@dtor-ws>
References: <1414057207-1576-1-git-send-email-caesar.wang@rock-chips.com>
 <1414057207-1576-4-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414057207-1576-4-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Caesar,

On Thu, Oct 23, 2014 at 05:40:05PM +0800, Caesar Wang wrote:
> This patch changes a dtsi file to contain the thermal data
> on RK3288 and later SoCs. This data will
> enable a thermal shutdown over 125C.
> 
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>
> ---
>  arch/arm/boot/dts/rk3288-thermal.dtsi | 65 +++++++++++++++++++++++++++++++++++
>  1 file changed, 65 insertions(+)
>  create mode 100644 arch/arm/boot/dts/rk3288-thermal.dtsi
> 
> diff --git a/arch/arm/boot/dts/rk3288-thermal.dtsi b/arch/arm/boot/dts/rk3288-thermal.dtsi
> new file mode 100644
> index 0000000..c361262
> --- /dev/null
> +++ b/arch/arm/boot/dts/rk3288-thermal.dtsi
> @@ -0,0 +1,65 @@
> +/*
> + * Device Tree Source for RK3288 SoC thermal
> + *
> + * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2.  This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#include <dt-bindings/thermal/thermal.h>
> +
> +reserve_thermal: reserve_thermal {
> +	polling-delay-passive = <500>; /* milliseconds */
> +	polling-delay = <1000>; /* milliseconds */
> +
> +			/* sensor	ID */
> +	thermal-sensors = <&tsadc	0>;
> +
> +};
> +
> +cpu_thermal: cpu_thermal {
> +	polling-delay-passive = <500>; /* milliseconds */
> +	polling-delay = <1000>; /* milliseconds */

Given that the hardware supports alarm interrupts I think we should be
able to lower polling frequency. I'd say 5 seconds for polling-delay and
1 second for when we trip over passive point?

Thanks.

-- 
Dmitry
