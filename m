Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab3HSL0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:26:31 -0400
Received: from [94.18.233.162] ([94.18.233.162]:2638 "EHLO mail.secomea.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3HSL03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:26:29 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Aug 2013 07:26:29 EDT
Message-ID: <5211FED3.4090102@secomea.dk>
Date: Mon, 19 Aug 2013 13:17:39 +0200
From: =?ISO-8859-1?Q?Svenning_S=F8rensen?= <sss@secomea.dk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Felipe Balbi <balbi@ti.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] usb: musb: dsps: simplify platform_get_resource_byname/devm_ioremap_resource
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr> <1376902316-18520-5-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1376902316-18520-5-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19-08-2013 10:51, Julia Lawall wrote:
> diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
> index 4ffbaac..f2f9710 100644
> --- a/drivers/usb/musb/musb_dsps.c
> +++ b/drivers/usb/musb/musb_dsps.c
> @@ -357,9 +357,6 @@ static int dsps_musb_init(struct musb *musb)
>   	u32 rev, val;
>   
>   	r = platform_get_resource_byname(parent, IORESOURCE_MEM, "control");
> -	if (!r)
> -		return -EINVAL;
> -
>   	reg_base = devm_ioremap_resource(dev, r);
>   	if (!musb->ctrl_base)
>   		return -EINVAL;
Not really related to Julia's patch, apart from making it more obvious 
that there's a bug here.
I believe it is reg_base that needs to be checked, right?

Svenning
