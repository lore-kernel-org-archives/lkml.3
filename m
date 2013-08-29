Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3H2Qsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:48:43 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:58029 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3H2Qsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:48:42 -0400
Message-ID: <521F7B04.6040200@gmail.com>
Date: Thu, 29 Aug 2013 18:47:00 +0200
From: Wladislav Wiebe <wladislav.kw@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] of/fdt: Remove duplicate memory clearing on FDT unflattening
References: <1377783892-13226-1-git-send-email-grant.likely@linaro.org>
In-Reply-To: <1377783892-13226-1-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/13 15:44, Grant Likely wrote:
> Patch 9e4012752, "of: fdt: fix memory initialization for expanded DT"
> fixed incomplete clearing of memory when unflattening the device tree.
> However the code was already clearing some of the memory, it just wasn't
> doing so for all allocations. Now that the memory is cleared right at
> the point of allocation, the memset after unflatten_dt_alloc() is
> redundant. Remove it.

Acked-by: Wladislav Wiebe <wladislav.kw@gmail.com>

> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Wladislav Wiebe <wladislav.kw@gmail.com>
> ---
>  drivers/of/fdt.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 55b028f..9d9be9617 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -202,7 +202,6 @@ static void * unflatten_dt_node(struct boot_param_header *blob,
>  				__alignof__(struct device_node));
>  	if (allnextpp) {
>  		char *fn;
> -		memset(np, 0, sizeof(*np));
>  		np->full_name = fn = ((char *)np) + sizeof(*np);
>  		if (new_format) {
>  			/* rebuild full path for new format */
> 

