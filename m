Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaKDQIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:08:50 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39334 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaKDQIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:08:46 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/fdt: Don't clear initial_boot_params
 =?iso-8859-1?Q?if=0D?= fdt_check_header() fails
To: Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20141029181500.16094.46561.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141029181500.16094.46561.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Date: Tue, 04 Nov 2014 16:08:39 +0000
Message-Id: <20141104160839.6F238C423D0@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014 12:15:00 -0600
, Bjorn Helgaas <bhelgaas@google.com>
 wrote:
> If the device tree pointer is NULL, early_init_dt_verify() fails, leaving
> initial_boot_params unchanged.  If the device tree pointer is non-NULL but
> invalid, early_init_dt_verify() again fails but this time it also clears
> initial_boot_params.
> 
> Leave initial_boot_params unchanged if the device tree pointer is invalid.
> This doesn't fix a bug, but it makes the behavior more consistent and
> easier to analyze.
> 
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Looks correct. Applied.

g.

> ---
>  drivers/of/fdt.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index d1ffca8b34ea..55a566a53f36 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -994,15 +994,12 @@ bool __init early_init_dt_verify(void *params)
>  	if (!params)
>  		return false;
>  
> -	/* Setup flat device-tree pointer */
> -	initial_boot_params = params;
> -
>  	/* check device tree validity */
> -	if (fdt_check_header(params)) {
> -		initial_boot_params = NULL;
> +	if (fdt_check_header(params))
>  		return false;
> -	}
>  
> +	/* Setup flat device-tree pointer */
> +	initial_boot_params = params;
>  	return true;
>  }
>  
> 

