Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaGCJE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:04:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:52729 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132AbaGCJEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:04:54 -0400
Date: Thu, 3 Jul 2014 10:04:47 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Daniel Jeong <gshark.jeong@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Daniel Jeong <daniel.jeong@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [RFC v4 2/2] backlight: device tree: add new tps611xx backlight
 binding
Message-ID: <20140703090447.GC29837@leverpostej>
References: <1404367277-12003-1-git-send-email-gshark.jeong@gmail.com>
 <1404367277-12003-3-git-send-email-gshark.jeong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404367277-12003-3-git-send-email-gshark.jeong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 07:01:17AM +0100, Daniel Jeong wrote:
> This commit is about tps611xx device tree documentation.
> 
> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
> ---
>  .../video/backlight/tps611xx-backlight.txt         |   24 ++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/backlight/tps611xx-backlight.txt
> 
> diff --git a/Documentation/devicetree/bindings/video/backlight/tps611xx-backlight.txt b/Documentation/devicetree/bindings/video/backlight/tps611xx-backlight.txt
> new file mode 100644
> index 0000000..7af8182
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/backlight/tps611xx-backlight.txt
> @@ -0,0 +1,24 @@
> +TPS611xx family of backlight driver based on EasyScale.
> +
> +EasyScale is a simple but flexible one pin interface to configure the current.
> +
> +Required properties:
> +- compatible: should contain at least one of
> +  "ti,tps61158_bl"
> +  "ti,tps61161_bl"
> +  "ti,tps61163_bl"
> +  "ti,tps61165_bl"

In v3 I asked you to get rid of the "_bl" suffix.

> +- rfa-enable: enable request for acknowledge.
> +  If RFA is enabled, the data byte includes the RFA bit and device will wait
> +  and check acknowledge from device.

You didn't answer my question as to why this should be in the DT.

> +- es-gpio : GPIO for easy-scale communication.(see GPIO binding[0])
> +
> +[0]: Documentation/devicetree/bindings/gpio/gpio.txt
> +
> +Example:
> +
> +	backlight {
> +		compatible = "ti,tps61163";

This now doesn't match the Documentation above.

Thanks,
Mark.

> +		rfa-enable;
> +		es-gpio = <&gpio 45 0>;
> +	};
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
