Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab3KONly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:41:54 -0500
Received: from mo2.mail-out.ovh.net ([178.32.228.2]:43621 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3KONls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:41:48 -0500
Date: Fri, 15 Nov 2013 14:44:00 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, nicolas.ferre@atmel.com,
        alexandre.belloni@free-electrons.com, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        galak@codeaurora.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v7 2/2] PWM: atmel-pwm: add device tree binding document
Message-ID: <20131115134400.GN28304@ns203013.ovh.net>
References: <1384509208-10762-1-git-send-email-voice.shen@atmel.com>
 <1384509208-10762-2-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384509208-10762-2-git-send-email-voice.shen@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 2637983483287087923
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:53 Fri 15 Nov     , Bo Shen wrote:
> Add atmel pwm driver device tree binding document
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Acked-by: Kumar Gala <galak@codeaurora.org>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
> ---
> Changes in v7: None
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
> -- 
> 1.7.9.5
> 
