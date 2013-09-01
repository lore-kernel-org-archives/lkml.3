Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab3IARBb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 13:01:31 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54299 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab3IARB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 13:01:29 -0400
Message-ID: <522372EB.1060701@ti.com>
Date: Sun, 1 Sep 2013 20:01:31 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130808 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: <dmitry.torokhov@gmail.com>, Bill Pemberton <wfp5p@virginia.edu>,
        <broonie@opensource.wolfsonmicro.com>, <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] driver: input: twl4030-vibra: fix missing of_node_put
References: <522190ED.6020909@huawei.com>
In-Reply-To: <522190ED.6020909@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2013 09:45 AM, Libo Chen wrote:
> 
> decrease node device_node refcount after task completion
> 
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> ---
>  drivers/input/misc/twl4030-vibra.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
> index 68a5f33..b8d1526 100644
> --- a/drivers/input/misc/twl4030-vibra.c
> +++ b/drivers/input/misc/twl4030-vibra.c
> @@ -185,8 +185,10 @@ static bool twl4030_vibra_check_coexist(struct twl4030_vibra_data *pdata,
>  	if (pdata && pdata->coexist)
>  		return true;
> 
> -	if (of_find_node_by_name(node, "codec"))
> +	if (of_find_node_by_name(node, "codec")) {
> +		of_node_put(node);
>  		return true;
> +	}
> 
>  	return false;
>  }
> 


-- 
Péter
