Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab3APSjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:39:01 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:58535 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278Ab3APSi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:38:59 -0500
Message-ID: <50F70164.3080105@mvista.com>
Date: Wed, 16 Jan 2013 22:37:08 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: balbi@ti.com, sameo@linux.intel.com, tony@atomide.com, kishon@ti.com,
        bjorn@mork.no, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 03/22] mfd: omap-usb-tll: Use devm_kzalloc/ioremap
 and clean up error path
References: <1358347433-329-1-git-send-email-rogerq@ti.com> <1358347433-329-4-git-send-email-rogerq@ti.com>
In-Reply-To: <1358347433-329-4-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/16/2013 05:43 PM, Roger Quadros wrote:

> Use devm_ variants of kzalloc() and ioremap(). Simplify the error path.

> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/mfd/omap-usb-tll.c |   36 +++++++++++-------------------------
>  1 files changed, 11 insertions(+), 25 deletions(-)

> diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
> index 9658e18..53ed10b 100644
> --- a/drivers/mfd/omap-usb-tll.c
> +++ b/drivers/mfd/omap-usb-tll.c
[...]
> -	base = ioremap(res->start, resource_size(res));
> +	base = devm_request_and_ioremap(dev, res);
>  	if (!base) {
> -		dev_err(dev, "TLL ioremap failed\n");
>  		ret = -ENOMEM;

   -EADDRNOTAVAIL as the comment to devm_request_and_ioremap() suggests.

> -		goto err_usbtll_p2_fck;
> +		dev_err(dev, "Resource request/ioremap failed:%d\n", ret);
> +		goto err_res;
>  	}

WBR, Sergei

