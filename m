Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbaIHTcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:32:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52799 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbaIHTch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:32:37 -0400
Date: Mon, 8 Sep 2014 14:32:35 -0500
From: Nishanth Menon <nm@ti.com>
To: Mugunthan V N <mugunthanvnm@ti.com>
CC: <bcousson@baylibre.com>, <tony@atomide.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [resend PATCH 1/3] pinctrl: dra7: dt-bindings: add pin off modes
 for dra7 SoC
Message-ID: <20140908193235.GA12150@kahuna>
References: <1410203998-8700-1-git-send-email-mugunthanvnm@ti.com>
 <1410203998-8700-2-git-send-email-mugunthanvnm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410203998-8700-2-git-send-email-mugunthanvnm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 00:49-20140909, Mugunthan V N wrote:
> Add pin off modes for dra7 SoC so that during module disable or suspend
> state it can help saving power
> 
> Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
> ---
>  include/dt-bindings/pinctrl/dra.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/dt-bindings/pinctrl/dra.h b/include/dt-bindings/pinctrl/dra.h
> index 002a285..a0ff2d0 100644
> --- a/include/dt-bindings/pinctrl/dra.h
> +++ b/include/dt-bindings/pinctrl/dra.h
> @@ -46,5 +46,13 @@
>  #define PIN_INPUT_PULLUP	(PULL_ENA | INPUT_EN | PULL_UP)
>  #define PIN_INPUT_PULLDOWN	(PULL_ENA | INPUT_EN)
>  
> +/* Off mode states */
> +#define PIN_OFF_NONE		0
> +#define PIN_OFF_OUTPUT_HIGH	(OFF_EN | OFFOUT_EN | OFFOUT_VAL)
> +#define PIN_OFF_OUTPUT_LOW	(OFF_EN | OFFOUT_EN)
> +#define PIN_OFF_INPUT_PULLUP	(OFF_EN | OFF_PULL_EN | OFF_PULL_UP)
> +#define PIN_OFF_INPUT_PULLDOWN	(OFF_EN | OFF_PULL_EN)
> +#define PIN_OFF_WAKEUPENABLE	WAKEUP_EN
> +
>  #endif

NAK for OFF_NONE, OFF_xyz etc.

A) There is no OFF mode on DRA7. in sleep state use mode 15 (gated).
B) when using this for wakeup - use pinctrl wakeup handling to do the
wakeup.

Regards,
Nishanth Menon
