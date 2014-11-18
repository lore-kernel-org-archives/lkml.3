Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629AbaKRQ5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:57:45 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39275 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbaKRQ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:57:43 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/address: Don't throw errors on absent ranges
 properties
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1415948303.666.50.camel@kernel.crashing.org>
References: <1415948303.666.50.camel@kernel.crashing.org>
Date: Tue, 18 Nov 2014 16:57:39 +0000
Message-Id: <20141118165739.7382AC40966@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 17:58:23 +1100
, Benjamin Herrenschmidt <benh@kernel.crashing.org>
 wrote:
> The core always tries to translate any "reg" property to construct the platform
> device names. This results in a pile of "OF: no ranges; cannot translate" errors
> in dmesg whenever we expose things like i2c devices that cannot directly translate
> to the MMIO space.

I don't have a problem with the change, but it seems to be catching an
odd usage of of_device_make_bus_id(). Why is of_device_make_bus_id()
being called on i2c devices? Those shouldn't be modelled as
platform_devices.

g.

> 
> Turn this into a pr_debug instead
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index f0541fd..bf1f79d 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -444,7 +444,7 @@ static int of_translate_one(struct device_node *parent, struct of_bus *bus,
>  	 */
>  	ranges = of_get_property(parent, rprop, &rlen);
>  	if (ranges == NULL && !of_empty_ranges_quirk()) {
> -		pr_err("OF: no ranges; cannot translate\n");
> +		pr_debug("OF: no ranges; cannot translate\n");
>  		return 1;
>  	}
>  	if (ranges == NULL || rlen == 0) {
> 
> 

