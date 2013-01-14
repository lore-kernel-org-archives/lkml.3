Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438Ab3ANO5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 09:57:18 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:53228 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab3ANO5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 09:57:16 -0500
Message-ID: <50F41CC9.1000105@gmail.com>
Date: Mon, 14 Jan 2013 08:57:13 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Matt Porter <mporter@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Russ Dill <Russ.Dill@ti.com>
Subject: Re: [PATCH] OF: Link platform device resources properly.
References: <1357252284-5990-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1357252284-5990-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 04:31 PM, Pantelis Antoniou wrote:
> The resources of the platform devices created by the OF core were
> not properly linked. Make sure that they are, so that we don't get
> any crashes when trying to remove the device.
> 
> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/of/device.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/of/device.c b/drivers/of/device.c
> index 4c74e4f..d75fcaf 100644
> --- a/drivers/of/device.c
> +++ b/drivers/of/device.c
> @@ -62,6 +62,9 @@ int of_device_add(struct platform_device *ofdev)
>  	if (!ofdev->dev.parent)
>  		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
>  
> +	/* make sure we add the resources to the appropriate lists */
> +	platform_device_link_resources(ofdev);
> +

Submit this with the patch that adds this function or state the
dependency please.

Rob

>  	return device_add(&ofdev->dev);
>  }
>  
> 
