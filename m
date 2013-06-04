Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295Ab3FDSZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:25:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58255 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3FDSZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:25:38 -0400
Message-ID: <51AE311F.5060900@lvivier.info>
Date: Tue, 04 Jun 2013 20:25:35 +0200
From: Laurent Vivier <Laurent@lvivier.info>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] swim: Release memory region after incorrect return/goto
References: <60123fd3175b7cceadf6c335b12e58b797e18f65.1370356776.git.joe@perches.com>
In-Reply-To: <60123fd3175b7cceadf6c335b12e58b797e18f65.1370356776.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:0lxmM15TK+emNWheD8/pkRE+aT3YOFyA0tS9WZcWjn/
 CqPzSkVUEVxDn9l1K6imLdLn4ZMPfFFWIveNuz+oZFBfXxIxJV
 v6iQj9oF5o5dgiuAeKN1upRQx+gdXl308WdAe8aY4NqWq8wBqv
 FRo2EkpHwPR5X99lm7J2MPtRxy3rXlg5OO1GqMP+fVRnkp7doN
 anh6+R4gAuV5EPveLixOLOMfGs5THHqvytqmQ5d1tRNvxZlZRY
 irtUpporwEexDxsHoZB++RwMDlpYTugDtErVVevP0bM5txaIeD
 pr5Zv1Wnrtht72K/V8QW8HS6pl8Lh2/R7XXNktGTo+YzoyHJ42
 JfhXRP1jBRsooXOwuJH4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/06/2013 16:44, Joe Perches a écrit :
> The code uses
>
> 	return foo;
> 	goto err_type;
>
> when instead the form should have been
>
> 	ret = foo;
> 	goto err_type;
>
> Here this causes a useful release_mem_region to be skipped.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>   drivers/block/swim.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/block/swim.c b/drivers/block/swim.c
> index 2f445b7..8ed6ccb 100644
> --- a/drivers/block/swim.c
> +++ b/drivers/block/swim.c
> @@ -893,7 +893,7 @@ static int swim_probe(struct platform_device *dev)
>   
>   	swim_base = ioremap(res->start, resource_size(res));
>   	if (!swim_base) {
> -		return -ENOMEM;
> +		ret = -ENOMEM;
>   		goto out_release_io;
>   	}
>   

Reviewed-by: Laurent Vivier <Laurent@Vivier.EU>
