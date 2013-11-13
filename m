Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab3KMJ0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 04:26:39 -0500
Received: from top.free-electrons.com ([176.31.233.9]:47103 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932344Ab3KMJ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 04:26:34 -0500
Message-ID: <528345BF.2080207@free-electrons.com>
Date: Wed, 13 Nov 2013 17:26:23 +0800
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, devicetree@vger.kernel.org
CC: linux-pwm@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>, plagnioj@jcrosoft.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 2/2] PWM: atmel-pwm: add device tree binding document
References: <1383292811-11343-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1383292811-11343-1-git-send-email-voice.shen@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 16:00, Bo Shen wrote:
> Add atmel pwm driver device tree binding document
>
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>
> ---
> Changes in v6:
>   - New, split binding document as a separate patch
>
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
>
>  .../devicetree/bindings/pwm/atmel-pwm.txt          |   41 ++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/atmel-pwm.txt
>
> diff --git a/Documentation/devicetree/bindings/pwm/atmel-pwm.txt b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
> new file mode 100644
> index 0000000..1c1a5fa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/atmel-pwm.txt
> @@ -0,0 +1,41 @@
> +Atmel PWM controller
> +
> +Required properties:
> +  - compatible: should be one of:
> +    - "atmel,at91sam9rl-pwm"
> +    - "atmel,sama5d3-pwm"
> +  - reg: physical base address and length of the controller's registers
> +  - #pwm-cells: Should be 3. See pwm.txt in this directory for a
> +    description of the cells format
> +
> +Example:
> +
> +	pwm0: pwm@f8034000 {
> +		compatible = "atmel,at91sam9rl-pwm";
> +		reg = <0xf8034000 0x400>;
> +		#pwm-cells = <3>;
> +	};
> +
> +The following the pwm led based example:
> +
> +	pwm0: pwm@f8034000 {
> +		compatible = "atmel,at91sam9rl-pwm";
> +		reg = <0xf8034000 0x400>;
> +		#pwm-cells = <3>;
> +	};
> +
> +	pwdleds {
> +		compatible = "pwm-leds";
> +
> +		d1 {
> +			label = "d1";
> +			pwms = <&pwm0 3 5000 0>
> +			max-brightness = <255>;
> +		};
> +
> +		d2 {
> +			label = "d2";
> +			pwms = <&pwm0 1 5000 1>
> +			max-brightness = <255>;
> +		};
> +	};


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

