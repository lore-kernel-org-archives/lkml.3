Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaBXT2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:28:22 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6007 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304AbaBXT2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:28:20 -0500
Date: Mon, 24 Feb 2014 11:28:13 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Josh Cartwright <joshc@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Randy Dunlap <rdunlap@infradead.org>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 17 (pinctrl-msm)
Message-ID: <20140224192813.GA4451@sonymobile.com>
References: <20140217172329.2c61499f57842ec2ed177bc5@canb.auug.org.au>
 <530247FC.90606@infradead.org>
 <CACRpkdamW1-CxZV65at3PaPhY5nANRDd=SY=FsNPVnrPxyD81w@mail.gmail.com>
 <20140224174646.GA32621@sonymobile.com>
 <530B8C15.50100@infradead.org>
 <20140224184120.GB18563@joshc.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140224184120.GB18563@joshc.qualcomm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 24 Feb 10:41 PST 2014, Josh Cartwright wrote:

[...]

> 
> Without too much effort, I can get this to fail just by making
> CONFIG_PINCTRL_MSM=m.  handle_bad_irq isn't marked EXPORT_SYMBOL*, so
> hence the warning.
> 

Ohh, yeah I missed that.

> Whether or not this is intentional is not clear.  Do we support modules
> installing chained irq handlers?
> 
> For now, the patch below just makes this driver 'bool' instead of
> 'tristate'.

This comes from the request of having everything as a module, to reduce the
size of the multi-platform ARM builds. I would say that the important part
related to that would be to keep the platform specific tables in modules.

But keeping these parts as modules would still mean that it's a module that
install the chained irq handler.

@Linus, I'm not sure about what should be module and not in pinctrl, but this
part of pinctrl-msm is less important then the others to be able to be compiled
as a module.

FWIW;
Reviewed-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>

> 
>   Josh

Regards,
Bjorn

> 
> --8<--
> Subject: [PATCH] pinctrl: msm: make PINCTRL_MSM bool instead of tristate
> 
> Modular builds of pinctrl-msm break due to handle_bad_irq being
> unexported for module use.  For now, make PINCTRL_MSM 'bool'.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  drivers/pinctrl/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index be361b7..1e4e693 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -217,7 +217,7 @@ config PINCTRL_IMX28
>  	select PINCTRL_MXS
>  
>  config PINCTRL_MSM
> -	tristate
> +	bool
>  	select PINMUX
>  	select PINCONF
>  	select GENERIC_PINCONF
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
