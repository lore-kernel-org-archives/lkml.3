Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaHGVuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 17:50:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaHGVuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 17:50:14 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Felipe Balbi <balbi@ti.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] usb: gadget: fix error return code
References: <1407445067-4044-1-git-send-email-Julia.Lawall@lip6.fr>
	<1407445067-4044-5-git-send-email-Julia.Lawall@lip6.fr>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 07 Aug 2014 17:50:08 -0400
In-Reply-To: <1407445067-4044-5-git-send-email-Julia.Lawall@lip6.fr> (Julia
	Lawall's message of "Thu, 7 Aug 2014 22:57:47 +0200")
Message-ID: <x49oavw9dgv.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <Julia.Lawall@lip6.fr> writes:

> diff --git a/drivers/usb/gadget/udc/fusb300_udc.c b/drivers/usb/gadget/udc/fusb300_udc.c
> index d40255f..5c5d1ad 100644
> --- a/drivers/usb/gadget/udc/fusb300_udc.c
> +++ b/drivers/usb/gadget/udc/fusb300_udc.c
> @@ -1398,13 +1398,17 @@ static int fusb300_probe(struct platform_device *pdev)
>  
>  	/* initialize udc */
>  	fusb300 = kzalloc(sizeof(struct fusb300), GFP_KERNEL);
> -	if (fusb300 == NULL)
> +	if (fusb300 == NULL) {
> +		ret = -ENOMEM;
>  		goto clean_up;
> +	}
>  
>  	for (i = 0; i < FUSB300_MAX_NUM_EP; i++) {
>  		_ep[i] = kzalloc(sizeof(struct fusb300_ep), GFP_KERNEL);
> -		if (_ep[i] == NULL)
> +		if (_ep[i] == NULL) {
> +			ret = -ENOMEM;
>  			goto clean_up;
> +		}
>  		fusb300->ep[i] = _ep[i];
>  	}

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
