Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaF1Ng2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 09:36:28 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:39498 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaF1Ng0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 09:36:26 -0400
Message-ID: <53AEC4D7.50205@ti.com>
Date: Sat, 28 Jun 2014 08:36:23 -0500
From: Nishanth Menon <nm@ti.com>
Reply-To: nm@ti.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: Kevin Hilman <khilman@kernel.org>, linux-pm@vger.kernel.org,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/1] drivers/power/avs/smartreflex.c: remove unnecessary
 null test before debugfs_remove_recursive
References: <1403958799-4692-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1403958799-4692-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor fix of $subject to be inline with existing logs needed.
PM / AVS: SmartReflex: ..

On 06/28/2014 07:33 AM, Fabian Frederick wrote:
> Fix checkpatch warning:
> WARNING: debugfs_remove_recursive(NULL) is safe this check is probably not required
>
> Cc: Kevin Hilman <khilman@kernel.org>
> Cc: Nishanth Menon <nm@ti.com>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>   drivers/power/avs/smartreflex.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
> index db9973b..ecc5979 100644
> --- a/drivers/power/avs/smartreflex.c
> +++ b/drivers/power/avs/smartreflex.c
> @@ -1001,8 +1001,7 @@ static int omap_sr_remove(struct platform_device *pdev)
>
>   	if (sr_info->autocomp_active)
>   		sr_stop_vddautocomp(sr_info);
> -	if (sr_info->dbg_dir)
> -		debugfs_remove_recursive(sr_info->dbg_dir);
> +	debugfs_remove_recursive(sr_info->dbg_dir);
>
>   	pm_runtime_disable(&pdev->dev);
>   	list_del(&sr_info->node);
>
Acked-by: Nishanth Menon <nm@ti.com>
