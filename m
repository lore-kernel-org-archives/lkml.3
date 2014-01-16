Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaAPRaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:30:35 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:53647 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaAPRad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:30:33 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: Fix __of_device_is_available check
To: Xiubo Li <Li.Xiubo@freescale.com>, robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiubo Li <Li.Xiubo@freescale.com>
In-Reply-To: <1389582448-7489-1-git-send-email-Li.Xiubo@freescale.com>
References: <1389582448-7489-1-git-send-email-Li.Xiubo@freescale.com>
Date: Thu, 16 Jan 2014 17:30:27 +0000
Message-Id: <20140116173027.E887FC40973@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jan 2014 11:07:28 +0800, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> From IEEE 1275, there defined a standard 'status' property indicating the
> operational status of one device. The 'status' property has four possible
> values: 'okay/ok', 'disabled', 'fail' and 'fail-xxx'.
> 
> If it is absent, that means the status of the device is unknown or okay.
> 
> The __of_device_is_available checks the state of the 'status' property of
> a device. If the property is absent or set to 'okay/ok', it returns 1.
> Otherwise it returns 0.
> 
> While in __of_device_is_available:
>  >	status = of_get_property(device, "status", &statlen);
>  >	if (status == NULL)
>  >		return 1;
> The status value returned from 'of_get_property()' will be NULL in two cases:
> Firstly: the 'device' value (device node) is NULL.
> Secondly: the 'status' property is actaully not exist.
> 
> If the device node is NULL, the __of_device_is_available will return true,
> that will mean the absent state of the 'status' property.
> 
> So this add the device node check before checking the 'status' property's
> state, and if the device node is not exist, 0 will be returned.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>

Applied, thanks

g.

> ---
>  drivers/of/base.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index f807d0e..ba195fb 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -415,6 +415,9 @@ static int __of_device_is_available(const struct device_node *device)
>  	const char *status;
>  	int statlen;
>  
> +	if (!device)
> +		return 0;
> +
>  	status = __of_get_property(device, "status", &statlen);
>  	if (status == NULL)
>  		return 1;
> -- 
> 1.8.4
> 
> 

