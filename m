Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3EPL3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:29:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:38201 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab3EPL3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:29:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,683,1363158000"; 
   d="scan'208";a="303337501"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 21/33] drivers/usb/chipidea: don't check resource with devm_ioremap_resource
In-Reply-To: <1368702961-4325-22-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de> <1368702961-4325-22-git-send-email-wsa@the-dreams.de>
User-Agent: Notmuch/0.12+187~ga2502b0 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 16 May 2013 14:29:19 +0300
Message-ID: <87wqqzjh80.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wolfram Sang <wsa@the-dreams.de> writes:

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>

> ---
>  drivers/usb/chipidea/core.c |    5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index 450107e..49b098b 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -370,11 +370,6 @@ static int ci_hdrc_probe(struct platform_device *pdev)
>  	}
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(dev, "missing resource\n");
> -		return -ENODEV;
> -	}
> -
>  	base = devm_ioremap_resource(dev, res);
>  	if (IS_ERR(base))
>  		return PTR_ERR(base);
> -- 
> 1.7.10.4
