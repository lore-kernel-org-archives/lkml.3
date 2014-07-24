Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935226AbaGXKIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:08:39 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60669 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934765AbaGXKIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 06:08:37 -0400
MIME-Version: 1.0
In-Reply-To: <1405476113-10127-1-git-send-email-huayi.li@csr.com>
References: <1405476113-10127-1-git-send-email-huayi.li@csr.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 24 Jul 2014 18:08:16 +0800
Message-ID: <CAGsJ_4y4fw4rfkhntMYG19USsaxBhsyCj41wDDeXDURvR3XEEg@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] pwm: sirf: add dt-binding document
To: Huayi Li <huayi.li@csr.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rongjun Ying <rongjun.ying@csr.com>, Barry Song <barry.song@csr.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-16 10:01 GMT+08:00 Huayi Li <huayi.li@csr.com>:
> This patch adds dt-binding document for pwm-sirf. here the controller clock
> can't generate PWM signals, so we need seperate clock as signal source.
>
> Signed-off-by: Huayi Li <huayi.li@csr.com>

Reviewed-by: Barry Song <Baohua.Song@csr.com>

except that the commit log has not explained enough clearly that every
pwm channel can choice one from five clock sources to generate PWM
wave.

> ---
>  Documentation/devicetree/bindings/pwm/pwm-sirf.txt | 29 ++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-sirf.txt
>
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-sirf.txt b/Documentation/devicetree/bindings/pwm/pwm-sirf.txt
> new file mode 100644
> index 0000000..221e5d9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-sirf.txt
> @@ -0,0 +1,29 @@
> +SiRF prima2 & atlas6 PWM drivers
> +
> +Required properties:
> +- compatible: "sirf,prima2-pwm"
> +- reg: physical base address and length of the controller's registers
> +- #pwm-cells: should be 2. See pwm.txt in this directory for a description of
> +  the cells format.
> +- clocks: Must contain an entry for each entry in clock-names.
> +  See ../clock/prima2-clock.txt for details.
> +- clock-names: Must include the following entries:
> +  of clock sources to generate PWM signal,
> +  - pwmc: PWM controller clock
> +  - sigsrc0: source clock 0 for PWM
> +  - sigsrc1: source clock 1 for PWM
> +  - sigsrc2: source clock 2 for PWM
> +  - sigsrc3: source clock 3 for PWM
> +  - sigsrc4: source clock 4 for PWM
> +
> +Example:
> +
> +pwm: pwm@b0130000 {
> +       compatible = "sirf,prima2-pwm";
> +       #pwm-cells = <2>;
> +       reg = <0xb0130000 0x10000>;
> +       clocks = <&clks 21>, <&clks 1>, <&clks 2>,
> +              <&clks 3>, <&clks 0>, <&clks 4>;
> +       clock-names = "pwmc", "sigsrc0", "sigsrc1",
> +               "sigsrc2", "sigsrc3", "sigsrc4";
> +};
> --
> 1.9.3
>

-barry
