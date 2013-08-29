Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3H2QtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:49:22 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:34519 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab3H2QtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:49:20 -0400
Message-ID: <521F7B2A.5030106@gmail.com>
Date: Thu, 29 Aug 2013 18:47:38 +0200
From: Wladislav Wiebe <wladislav.kw@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] of: Fix missing memory initialization on FDT unflattening
References: <1377776494-27040-1-git-send-email-grant.likely@linaro.org>
In-Reply-To: <1377776494-27040-1-git-send-email-grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/13 13:41, Grant Likely wrote:
> Any calls to dt_alloc() need to be zeroed. This is a temporary fix, but
> the allocation function itself needs to zero memory before returning
> it. This is a follow up to patch 9e4012752, "of: fdt: fix memory
> initialization for expanded DT" which fixed one call site but missed
> another.

Acked-by: Wladislav Wiebe <wladislav.kw@gmail.com>

> 
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: stable@vger.kernel.org
> Cc: Wladislav Wiebe <wladislav.kw@gmail.com>
> ---
>  drivers/of/base.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 5c54279..bf8432f 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1629,6 +1629,7 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>  		ap = dt_alloc(sizeof(*ap) + len + 1, 4);
>  		if (!ap)
>  			continue;
> +		memset(ap, 0, sizeof(*ap) + len + 1);
>  		ap->alias = start;
>  		of_alias_add(ap, np, id, start, len);
>  	}
> 

