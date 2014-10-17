Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaJQJDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 05:03:42 -0400
Received: from mx0.aculab.com ([213.249.233.131]:50717 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750891AbaJQJDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 05:03:40 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Sudip Mukherjee'" <sudipm.mukherjee@gmail.com>,
        Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] usb: dwc2: gadget: modify return statement
Thread-Topic: [PATCH v3 2/2] usb: dwc2: gadget: modify return statement
Thread-Index: AQHP6cTt2/7fXiAO/UO/BExC6Ff6Q5wz/esQ
Date: Fri, 17 Oct 2014 09:02:00 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9D8926@AcuExch.aculab.com>
References: <1413521043-7587-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1413521043-7587-2-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1413521043-7587-2-git-send-email-sudipm.mukherjee@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Of Sudip Mukherjee
> modified the function to have a single return statement at the end
> instead of multiple return statement in the middle of the function
> to improve the readability of the code.

Many of us would disagree with you there.
Early returns actually make the code easier to read, certainly
better than a goto 'end of function'.

	David

> This patch depends on the previous patch of the series.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/usb/dwc2/gadget.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index 7f25527..e8a8fc7 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -2471,7 +2471,8 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
>  	dir_in = (desc->bEndpointAddress & USB_ENDPOINT_DIR_MASK) ? 1 : 0;
>  	if (dir_in != hs_ep->dir_in) {
>  		dev_err(hsotg->dev, "%s: direction mismatch!\n", __func__);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto error1;
>  	}
> 
>  	mps = usb_endpoint_maxp(desc);
> @@ -2583,6 +2584,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
> 
>  error:
>  	spin_unlock_irqrestore(&hsotg->lock, flags);
> +error1:
>  	return ret;
>  }
> 
> --
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


