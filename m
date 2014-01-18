Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaARF1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 00:27:04 -0500
Received: from 8.mo2.mail-out.ovh.net ([188.165.52.147]:59719 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751602AbaARF1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 00:27:00 -0500
Date: Sat, 18 Jan 2014 06:20:59 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Bo Shen <voice.shen@atmel.com>
Cc: Felipe Balbi <balbi@ti.com>, nicolas.ferre@atmel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] USB: at91: fix the number of endpoint parameter
Message-ID: <20140118052059.GL9558@ns203013.ovh.net>
References: <1389927565-22477-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389927565-22477-1-git-send-email-voice.shen@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 1082271287561923379
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrgeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:59 Fri 17 Jan     , Bo Shen wrote:
> In sama5d3 SoC, there are 16 endpoints. As the USBA_NR_ENDPOINTS
> is only 7. So, fix it for sama5d3 SoC using the udc->num_ep.
> 
> Signed-off-by: Bo Shen <voice.shen@atmel.com>
> ---
> 
>  drivers/usb/gadget/atmel_usba_udc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 2cb52e0..7e67a81 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -1670,7 +1670,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
>  	if (ep_status) {
>  		int i;
>  
> -		for (i = 0; i < USBA_NR_ENDPOINTS; i++)
> +		for (i = 0; i < udc->num_ep; i++)

no the limit need to specified in the driver as a checkpoint by the compatible
or platform driver id

Best Regards,
J.
>  			if (ep_status & (1 << i)) {
>  				if (ep_is_control(&udc->usba_ep[i]))
>  					usba_control_irq(udc, &udc->usba_ep[i]);
> -- 
> 1.8.5.2
> 
