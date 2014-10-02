Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaJBNPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:15:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46085 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJBNPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:15:00 -0400
Message-ID: <542D4FD0.9050606@codeaurora.org>
Date: Thu, 02 Oct 2014 16:14:56 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] UBI: Fastmap: Calc fastmap size correctly
References: <1412029248-22454-1-git-send-email-richard@nod.at> <1412029248-22454-3-git-send-email-richard@nod.at>
In-Reply-To: <1412029248-22454-3-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/2014 1:20 AM, Richard Weinberger wrote:
> We need to add fm_sb too.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   drivers/mtd/ubi/fastmap.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
> index 0431b46..2b0d8d6 100644
> --- a/drivers/mtd/ubi/fastmap.c
> +++ b/drivers/mtd/ubi/fastmap.c
> @@ -24,7 +24,8 @@ size_t ubi_calc_fm_size(struct ubi_device *ubi)
>   {
>   	size_t size;
>
> -	size = sizeof(struct ubi_fm_hdr) + \
> +	size = sizeof(struct ubi_fm_sb) + \
> +		sizeof(struct ubi_fm_hdr) + \
>   		sizeof(struct ubi_fm_scan_pool) + \
>   		sizeof(struct ubi_fm_scan_pool) + \
>   		(ubi->peb_count * sizeof(struct ubi_fm_ec)) + \
>

Not sure what's the proper way doing this (Reviewed-by/Acked-by) but I 
agree this patch is required. I would just elaborate a bit more on the 
commit message.

Thanks,
Tanya Brokhman
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation
