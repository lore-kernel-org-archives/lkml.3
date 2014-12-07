Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaLGOFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 09:05:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:47622 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbaLGOFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 09:05:15 -0500
Message-ID: <54845E96.1020900@codeaurora.org>
Date: Sun, 07 Dec 2014 16:05:10 +0200
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] UBI: Fastmap: Wrap fastmap specific function in a
 ifdef
References: <1417347340-6872-1-git-send-email-richard@nod.at> <1417347340-6872-5-git-send-email-richard@nod.at>
In-Reply-To: <1417347340-6872-5-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 1:35 PM, Richard Weinberger wrote:
> ...such that we can implement NOP variants of some functions.
> This will help to reduce fastmap specific ifdefs in other c files.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Reviewed-by: Tanya Brokhman <tlinder@codeaurora.org>

> ---
>   drivers/mtd/ubi/ubi.h | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
> index d672412..6fadf34 100644
> --- a/drivers/mtd/ubi/ubi.h
> +++ b/drivers/mtd/ubi/ubi.h
> @@ -864,10 +864,14 @@ int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
>   		      int pnum, const struct ubi_vid_hdr *vid_hdr);
>
>   /* fastmap.c */
> +#ifdef CONFIG_MTD_UBI_FASTMAP
>   size_t ubi_calc_fm_size(struct ubi_device *ubi);
>   int ubi_update_fastmap(struct ubi_device *ubi);
>   int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
>   		     int fm_anchor);
> +#else
> +static inline int ubi_update_fastmap(struct ubi_device *ubi) { return 0; }
> +#endif
>
>   /* block.c */
>   #ifdef CONFIG_MTD_UBI_BLOCK
>


Thanks,
Tanya Brokhman
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
