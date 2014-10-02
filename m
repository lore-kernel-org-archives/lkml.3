Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaJBNFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:05:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44051 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaJBNF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:05:29 -0400
Message-ID: <542D4D95.6000503@codeaurora.org>
Date: Thu, 02 Oct 2014 16:05:25 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>, dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] UBI: Ensure that all fastmap work is done upon WL
 shutdown
References: <1412029248-22454-1-git-send-email-richard@nod.at> <1412029248-22454-2-git-send-email-richard@nod.at>
In-Reply-To: <1412029248-22454-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On 9/30/2014 1:20 AM, Richard Weinberger wrote:
> ...otherwise the deferred work might run after datastructures
> got freed and corrupt memory.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   drivers/mtd/ubi/wl.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
> index 20f491713..dc01b1f 100644
> --- a/drivers/mtd/ubi/wl.c
> +++ b/drivers/mtd/ubi/wl.c
> @@ -2029,6 +2029,9 @@ static void protection_queue_destroy(struct ubi_device *ubi)
>   void ubi_wl_close(struct ubi_device *ubi)
>   {
>   	dbg_wl("close the WL sub-system");
> +#ifdef CONFIG_MTD_UBI_FASTMAP
> +	flush_work(&ubi->fm_work);

flush_work returns bool. It might be useful to print that value for 
debugging.

> +#endif
>   	cancel_pending(ubi);
>   	protection_queue_destroy(ubi);
>   	tree_destroy(&ubi->used);
>

Thanks
Tanya Brokhman
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation
