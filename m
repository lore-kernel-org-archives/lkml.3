Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933338AbaLBWYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:24:30 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35599 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932550AbaLBWY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:24:28 -0500
MIME-Version: 1.0
In-Reply-To: <1417507529-13654-5-git-send-email-jack.yoo@skyworksinc.com>
References: <1417507529-13654-1-git-send-email-jack.yoo@skyworksinc.com> <1417507529-13654-5-git-send-email-jack.yoo@skyworksinc.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 2 Dec 2014 14:24:07 -0800
Message-ID: <CAK5ve-+tVD-9XpY3AdNYbBkLYokh+U_EADyMSO1iRNSfp7pQ6w@mail.gmail.com>
Subject: Re: [PATCH v9 4/8] devicetree: backlight: Add new SKY81452 backlight binding
To: gyungoh@gmail.com
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, jack.yoo@skyworksinc.com,
        lkml <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        heiko@sntech.de, Jason Cooper <jason@lakedaemon.net>,
        Thierry Reding <treding@nvidia.com>, florian.vaussard@epfl.ch,
        Jiri Kosina <trivial@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>, jic23@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 12:05 AM,  <gyungoh@gmail.com> wrote:
> From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
>
> Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>


Acked-by: Bryan Wu <cooloney@gmail.com>

Thanks,
-Bryan

> ---
> Changes v9:
> Nothing
>
> Changes v8:
> Renamed property names for backlight with vendor prefix
> Modified gpio-enable property to generic property for GPIO
> Made up the example for backlight DT
>
> Changes v7:
> Nothing
>
> Changes v6:
> Nothing
>
> Changes v5:
> Nothing
>
> Changes v4:
> Nothing
>
> Changes v3:
> Nothing
>
> Changes v2:
> Added reg attribute for I2C slave address
>
>  .../video/backlight/sky81452-backlight.txt         | 29 ++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
>
> diff --git a/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt b/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
> new file mode 100644
> index 0000000..8daebf5
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
> @@ -0,0 +1,29 @@
> +SKY81452-backlight bindings
> +
> +Required properties:
> +- compatible           : Must be "skyworks,sky81452-backlight"
> +
> +Optional properties:
> +- name                 : Name of backlight device. Default is 'lcd-backlight'.
> +- gpios                        : GPIO to use to EN pin.
> +                       See Documentation/devicetree/bindings/gpio/gpio.txt
> +- skyworks,en-channels : Enable mask for current sink channel 1 to 6.
> +- skyworks,ignore-pwm  : Ignore both PWM input
> +- skyworks,dpwm-mode   : Enable DPWM dimming mode, otherwise Analog dimming.
> +- skyworks,phase-shift : Enable phase shift mode
> +- skyworks,ovp-level   : Over-voltage protection level.
> +                       Should be between 14 or 28V.
> +- skyworks,short-detection-threshold   : It should be one of 4, 5, 6 and 7V.
> +- skyworks,current-limit       : It should be 2300mA or 2750mA.
> +
> +Example:
> +
> +       backlight {
> +               compatible = "skyworks,sky81452-backlight";
> +               name = "pwm-backlight";
> +               skyworks,en-channels = <0x3f>;
> +               skyworks,ignore-pwm;
> +               skyworks,phase-shift;
> +               skyworks,ovp-level = <20>;
> +               skyworks,current-limit = <2300>;
> +       };
> --
> 1.9.1
>
