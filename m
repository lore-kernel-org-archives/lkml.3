Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3LMLB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:01:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50493 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab3LMLBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:01:53 -0500
Message-ID: <52AAE8DE.2030801@ti.com>
Date: Fri, 13 Dec 2013 16:30:46 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Matt Porter <mporter@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
CC: Tomasz Figa <t.figa@samsung.com>, Kamil Debski <k.debski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v5 5/9] usb: gadget: s3c-hsotg: use generic phy_init()/phy_exit()
 support
References: <1386854770-2173-1-git-send-email-mporter@linaro.org> <1386854770-2173-6-git-send-email-mporter@linaro.org>
In-Reply-To: <1386854770-2173-6-git-send-email-mporter@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 December 2013 06:56 PM, Matt Porter wrote:
> If a generic phy is present, call phy_init()/phy_exit(). This supports
> generic phys that must be soft reset before power on.
> 
> Signed-off-by: Matt Porter <mporter@linaro.org>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/gadget/s3c-hsotg.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
> index 7c5d8bd..e9683c2 100644
> --- a/drivers/usb/gadget/s3c-hsotg.c
> +++ b/drivers/usb/gadget/s3c-hsotg.c
> @@ -3621,6 +3621,9 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
>  		goto err_supplies;
>  	}
>  
> +	if (hsotg->phy)
> +		phy_init(hsotg->phy);
> +
>  	/* usb phy enable */
>  	s3c_hsotg_phy_enable(hsotg);
>  
> @@ -3714,6 +3717,8 @@ static int s3c_hsotg_remove(struct platform_device *pdev)
>  	}
>  
>  	s3c_hsotg_phy_disable(hsotg);
> +	if (hsotg->phy)
> +		phy_exit(hsotg->phy);
>  	clk_disable_unprepare(hsotg->clk);
>  
>  	return 0;
> 

