Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaJQSwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 14:52:40 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:59458 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbaJQSwj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 14:52:39 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        "balbi@ti.com" <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] usb: dwc2: gadget: modify return statement
Thread-Topic: [PATCH v3 2/2] usb: dwc2: gadget: modify return statement
Thread-Index: AQHP6cUG28F+qHxVJUawV10ZLnQBUpw0ou0g
Date: Fri, 17 Oct 2014 18:52:37 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E347B@US01WEMBX2.internal.synopsys.com>
References: <1413521043-7587-1-git-send-email-sudipm.mukherjee@gmail.com>
 <1413521043-7587-2-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1413521043-7587-2-git-send-email-sudipm.mukherjee@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sudip Mukherjee [mailto:sudipm.mukherjee@gmail.com]
> Sent: Thursday, October 16, 2014 9:44 PM
> 
> modified the function to have a single return statement at the end
> instead of multiple return statement in the middle of the function
> to improve the readability of the code.
> 
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

According to the discussion in another thread, let's drop this patch.

-- 
Paul

