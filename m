Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab3BTTJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 14:09:09 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35365 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128Ab3BTTJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 14:09:08 -0500
Message-ID: <51251F51.2010003@gmail.com>
Date: Wed, 20 Feb 2013 13:09:05 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
CC: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/i2c: don't register disabled devices
References: <1361384904-13853-1-git-send-email-dmitry_eremin@mentor.com>
In-Reply-To: <1361384904-13853-1-git-send-email-dmitry_eremin@mentor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 12:28 PM, Dmitry Eremin-Solenikov wrote:
> Don't register i2c slave device tree nodes which have
> status = "disabled" property.
> 

This is already in 3.8.

Rob

> Signed-off-by: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
> ---
>  drivers/of/of_i2c.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/of/of_i2c.c b/drivers/of/of_i2c.c
> index 1e173f3..63f3236 100644
> --- a/drivers/of/of_i2c.c
> +++ b/drivers/of/of_i2c.c
> @@ -35,6 +35,9 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
>  		const __be32 *addr;
>  		int len;
>  
> +		if (!of_device_is_available(node))
> +			continue;
> +
>  		dev_dbg(&adap->dev, "of_i2c: register %s\n", node->full_name);
>  
>  		if (of_modalias_node(node, info.type, sizeof(info.type)) < 0) {
> 

