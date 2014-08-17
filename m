Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaHQAZf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 20:25:35 -0400
Received: from mail-yk0-f175.google.com ([209.85.160.175]:35347 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaHQAZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 20:25:33 -0400
Message-ID: <53EFF67A.6030401@acm.org>
Date: Sat, 16 Aug 2014 19:25:30 -0500
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] ipmi/of: Don't use unavailable interfaces
References: <1407998386.5490.62.camel@pasglop>
In-Reply-To: <1407998386.5490.62.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2014 01:39 AM, Benjamin Herrenschmidt wrote:
> If an IPMI controller is used by the firmware and as such marked with
> a reserved status, we shouldn't use it.

I've added this to my IPMI tree.  I can't comment on it's correctness,
others would know better than me, but it seems reasonable.

Thanks,

-corey

> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>
> Not tested, found by inspection as we are investigating how to plumb
> IPMI on one of our future platforms. Our FW uses the device-tree for
> its own internal use and tags stuff that it reserves for itself using
> the "status" property. This is likely to be the case of our BT interface.
>
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 5d66568..4fc8931 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -2658,6 +2658,9 @@ static int ipmi_probe(struct platform_device *dev)
>  	if (!match)
>  		return -EINVAL;
>  
> +	if (!of_device_is_available(np))
> +		return -EINVAL;
> +
>  	ret = of_address_to_resource(np, 0, &resource);
>  	if (ret) {
>  		dev_warn(&dev->dev, PFX "invalid address from OF\n");
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

