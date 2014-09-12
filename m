Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbaILQel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:34:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58284 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaILQej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:34:39 -0400
X-AuditID: cbfee61b-f79f86d00000144c-11-5413209d3240
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, balbi@ti.com,
        dinh.linux@gmail.com, swarren@wwwdotorg.org, matthijs@stdin.nl,
        r.baldyga@samsung.com, jg1.han@samsung.com, sachin.kamat@linaro.org,
        ben-linux@fluff.org, dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 09/12] usb: dwc2: initialize the spin_lock for both host
 and gadget
Date: Fri, 12 Sep 2014 18:34:19 +0200
Message-id: <4251641.n6Nv53rcYW@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1409070003-21195-10-git-send-email-dinguyen@opensource.altera.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
 <1409070003-21195-10-git-send-email-dinguyen@opensource.altera.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jAd25CsIhBg+vSlgcvF9vMWndASaL
	s8sOslms+rSG2WLlSW2L5sXr2SwuL7zEarFt+k8ga9ccNotFy1qZLRa+vsZisX3KdCaLB4d3
	sluc/NPLaPHqYBuLA7/H7IaLLB5/V71g9tg56y67x51re9g89s9dw+7Rf20Su8ffWftZPPq2
	rGL0+PLjH4vHlv2fGT2O39jO5PF5k5zHxrmhAbxRXDYpqTmZZalF+nYJXBnzf65jLLjCW7Gu
	5SVTA+Nk7i5GTg4JAROJvxP+skPYYhIX7q1n62Lk4hASWMQoMe3HeyaQhJBAC5PEt91yIDab
	gJXExPZVjCC2iICSRO+qlywgDcwCZ5kkVuxaywySEBaIluhdcpENxGYRUJWYureRBcTmFdCU
	OLzuPSuILSrgKbFj+0qwGk6BAIlNf5dBbZ7CKLHjxQNWiAZBiR+T74E1MwvIS+zbP5UVwtaR
	2N86jW0Co8AsJGWzkJTNQlK2gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwDD6T3sG4
	qsHiEKMAB6MSD28li2CIEGtiWXFl7iFGCQ5mJRFeRVHhECHelMTKqtSi/Pii0pzU4kOM0hws
	SuK8B1utA4UE0hNLUrNTUwtSi2CyTBycUg2MGXz3t3Q+5Nx5+I5s9qx7Xjrrj4VF6z2Z9Svo
	X31izcZPQnvvHWl5Kb9j4fVlJotEjkZxvqj87mIvb9D1JLDjWASH6db7vhwqx1c/iJ7u68O1
	rHuPe27Q3h/3Jk26vftCxPXG0k2ZO9+vOHuhvUAsJZ57Qc2zuZJP9vEYZk84Olu+oNosP1DD
	RYmlOCPRUIu5qDgRAOv/6Qy9AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-kernel ML to cc: ]

Hi,

On Tuesday, August 26, 2014 11:20:00 AM dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Move spin_lock_init to common location for both host and gadget.

This should be done at the same time that gadget/host probing is merged
to preserve bisectability.

Also patch #12 ("usb: dwc2: pci: Update pci portion of the dwc2 driver")
should be merged into this one.

> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> ---
> v4: move spin_lock_init up to make sure sure no locks can be taken before
>     the init.
> ---
>  drivers/usb/dwc2/hcd.c      | 1 -
>  drivers/usb/dwc2/platform.c | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
> index 07a7bcd..c6778d9 100644
> --- a/drivers/usb/dwc2/hcd.c
> +++ b/drivers/usb/dwc2/hcd.c
> @@ -2824,7 +2824,6 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg, int irq,
>  
>  	hcd->has_tt = 1;
>  
> -	spin_lock_init(&hsotg->lock);
>  	((struct wrapper_priv_data *) &hcd->hcd_priv)->hsotg = hsotg;
>  	hsotg->priv = hcd;
>  
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index 2871f351..278135d 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -183,6 +183,7 @@ static int dwc2_driver_probe(struct platform_device *dev)
>  
>  	hsotg->dr_mode = of_usb_get_dr_mode(dev->dev.of_node);
>  
> +	spin_lock_init(&hsotg->lock);
>  	if (IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)) {
>  		retval = dwc2_gadget_init(hsotg, irq);
>  		if (retval)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

