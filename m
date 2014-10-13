Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaJMU7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:59:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:50386 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbaJMU7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:59:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="399631572"
Date: Mon, 13 Oct 2014 13:59:37 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linus.walleij@linaro.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: baytrail: add missing module removal support
Message-ID: <20141013205937.GE4034@psi-dev26.jf.intel.com>
References: <1413233408-31923-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413233408-31923-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Oct 13, 2014 at 03:50:08PM -0500, Felipe Balbi wrote:
> pinctrl-baytrail driver provides a proper ->remove()
> method on its platform_driver definition, however there's
> no way, currently, to unload the driver due to missing
> module_exit(). This patch adds module_exit().
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>

This is a quite trivial patch, so not sure you need an Ack from somebody
that has the actual hw. In case you do:

Acked-by: David Cohen <david.a.cohen@linux.intel.com>

> ---
>  drivers/pinctrl/pinctrl-baytrail.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-baytrail.c b/drivers/pinctrl/pinctrl-baytrail.c
> index e12e5b0..3ece001 100644
> --- a/drivers/pinctrl/pinctrl-baytrail.c
> +++ b/drivers/pinctrl/pinctrl-baytrail.c
> @@ -612,5 +612,10 @@ static int __init byt_gpio_init(void)
>  {
>  	return platform_driver_register(&byt_gpio_driver);
>  }
> -
>  subsys_initcall(byt_gpio_init);
> +
> +static void __exit byt_gpio_exit(void)
> +{
> +	platform_driver_unregister(&byt_gpio_driver);
> +}
> +module_exit(byt_gpio_exit);
> -- 
> 2.1.0.GIT
> 
