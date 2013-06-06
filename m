Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab3FFQja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:39:30 -0400
Received: from 6.mo5.mail-out.ovh.net ([178.32.119.138]:46891 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751625Ab3FFQj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:39:29 -0400
Date: Thu, 6 Jun 2013 18:15:44 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, manabian@gmail.com,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@dominikbrodowski.net, fabio.porcedda@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>, laurent.navet@gmail.com,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH v3 1/7] pcmcia: at91_cf: fix gpio_get_value in
 at91_cf_get_status
Message-ID: <20130606161544.GN23653@game.jcrosoft.org>
References: <cover.1370506678.git.nicolas.ferre@atmel.com>
 <cc6a02cb9d55ba52b48adca688fef362b8bea373.1370506678.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc6a02cb9d55ba52b48adca688fef362b8bea373.1370506678.git.nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 13160081063166585708
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrfeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:24 Thu 06 Jun     , Nicolas Ferre wrote:
> From: Joachim Eastwood <manabian@gmail.com>
> 
> Commit 80af9e6d (pcmcia at91_cf: fix raw gpio number usage) forgot
> to change the parameter in gpio_get_value after adding gpio
> validation.

this is a fix so should for in stable tree too

since #3.4

Best Regards,
J.
> 
> Signed-off-by: Joachim Eastwood <manabian@gmail.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/pcmcia/at91_cf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pcmcia/at91_cf.c b/drivers/pcmcia/at91_cf.c
> index 01463c7..1b2c631 100644
> --- a/drivers/pcmcia/at91_cf.c
> +++ b/drivers/pcmcia/at91_cf.c
> @@ -100,9 +100,9 @@ static int at91_cf_get_status(struct pcmcia_socket *s, u_int *sp)
>  		int vcc	= gpio_is_valid(cf->board->vcc_pin);
>  
>  		*sp = SS_DETECT | SS_3VCARD;
> -		if (!rdy || gpio_get_value(rdy))
> +		if (!rdy || gpio_get_value(cf->board->irq_pin))
>  			*sp |= SS_READY;
> -		if (!vcc || gpio_get_value(vcc))
> +		if (!vcc || gpio_get_value(cf->board->vcc_pin))
>  			*sp |= SS_POWERON;
>  	} else
>  		*sp = 0;
> -- 
> 1.8.2.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
