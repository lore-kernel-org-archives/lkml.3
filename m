Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161959AbaKNVBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 16:01:52 -0500
Received: from smtprelay.synopsys.com ([198.182.44.111]:50887 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161709AbaKNVBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 16:01:51 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "balbi@ti.com" <balbi@ti.com>
CC: "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv7 6/8] usb: dwc2: gadget: Do not fail probe if there
 isn't a clock node
Thread-Topic: [PATCHv7 6/8] usb: dwc2: gadget: Do not fail probe if there
 isn't a clock node
Thread-Index: AQHP/dN8gtGG8ykNYkqz3x3SQs2DW5xgn/UA
Date: Fri, 14 Nov 2014 21:01:49 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844EBD12@US01WEMBX2.internal.synopsys.com>
References: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
 <1415726020-19238-7-git-send-email-dinguyen@opensource.altera.com>
In-Reply-To: <1415726020-19238-7-git-send-email-dinguyen@opensource.altera.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: dinguyen@opensource.altera.com [mailto:dinguyen@opensource.altera.com]
> Sent: Tuesday, November 11, 2014 9:14 AM
> 
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Since the dwc2 hcd driver is currently not looking for a clock node during
> init, we should not completely fail if there isn't a clock provided.
> By assigning clk = NULL, this allows the driver, when configured for dual-role
> mode, to be able to continue loading the host portion of the driver when
> a clock node is not specified.
> 
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> ---
> v7: Reworked to use clk=NULL and remove the need to is IS_ERR(clk)
> v6: none
> v5: reworked to not access gadget functions from the hcd.
> ---
>  drivers/usb/dwc2/gadget.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index 37c7916..367689b 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -3431,6 +3431,7 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
> 
>  	hsotg->clk = devm_clk_get(dev, "otg");
>  	if (IS_ERR(hsotg->clk)) {
> +		hsotg->clk = NULL;
>  		dev_err(dev, "cannot get otg clock\n");
>  		return PTR_ERR(hsotg->clk);
>  	}

Whoops, you just broke the return value, since you NULL out
hsotg->clk and then call PTR_ERR() on it.

-- 
Paul

