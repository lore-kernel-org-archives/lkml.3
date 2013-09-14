Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab3INQyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 12:54:36 -0400
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:38151 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932257Ab3INQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 12:54:34 -0400
Date: Sat, 14 Sep 2013 18:45:23 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [RFC PATCH 1/4] pinctrl: at91: fix typos
Message-ID: <20130914164523.GC11420@ns203013.ovh.net>
References: <1379058213-3245-1-git-send-email-b.brezillon@overkiz.com>
 <1379058333-3286-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379058333-3286-1-git-send-email-b.brezillon@overkiz.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 10550526552393100153
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09:45 Fri 13 Sep     , Boris BREZILLON wrote:
> Fix AT91_PINCTRL_DEBOUNCE_VAL dt macro typo.
> Fix at91_pinctrl_mux_ops callback typos.
> 
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  drivers/pinctrl/pinctrl-at91.c     |    6 +++---
>  include/dt-bindings/pinctrl/at91.h |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
> index 19afb9a..50b555a 100644
> --- a/drivers/pinctrl/pinctrl-at91.c
> +++ b/drivers/pinctrl/pinctrl-at91.c
> @@ -144,11 +144,11 @@ struct at91_pinctrl_mux_ops {
>  	void (*mux_C_periph)(void __iomem *pio, unsigned mask);
>  	void (*mux_D_periph)(void __iomem *pio, unsigned mask);
>  	bool (*get_deglitch)(void __iomem *pio, unsigned pin);
> -	void (*set_deglitch)(void __iomem *pio, unsigned mask, bool in_on);
> +	void (*set_deglitch)(void __iomem *pio, unsigned mask, bool is_on);
>  	bool (*get_debounce)(void __iomem *pio, unsigned pin, u32 *div);
> -	void (*set_debounce)(void __iomem *pio, unsigned mask, bool in_on, u32 div);
> +	void (*set_debounce)(void __iomem *pio, unsigned mask, bool is_on, u32 div);
>  	bool (*get_pulldown)(void __iomem *pio, unsigned pin);
> -	void (*set_pulldown)(void __iomem *pio, unsigned mask, bool in_on);
> +	void (*set_pulldown)(void __iomem *pio, unsigned mask, bool is_on);
>  	bool (*get_schmitt_trig)(void __iomem *pio, unsigned pin);
>  	void (*disable_schmitt_trig)(void __iomem *pio, unsigned mask);
>  	/* irq */
> diff --git a/include/dt-bindings/pinctrl/at91.h b/include/dt-bindings/pinctrl/at91.h
> index d7988b4..0fee6ff 100644
> --- a/include/dt-bindings/pinctrl/at91.h
> +++ b/include/dt-bindings/pinctrl/at91.h
> @@ -16,7 +16,7 @@
>  #define AT91_PINCTRL_PULL_DOWN		(1 << 3)
>  #define AT91_PINCTRL_DIS_SCHMIT		(1 << 4)
>  #define AT91_PINCTRL_DEBOUNCE		(1 << 16)
> -#define AT91_PINCTRL_DEBOUNCE_VA(x)	(x << 17)
> +#define AT91_PINCTRL_DEBOUNCE_VAL(x)	(x << 17)
>  
>  #define AT91_PINCTRL_PULL_UP_DEGLITCH	(AT91_PINCTRL_PULL_UP | AT91_PINCTRL_DEGLITCH)
>  
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
