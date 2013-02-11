Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab3BKWrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:47:15 -0500
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:56455 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776Ab3BKWrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:47:12 -0500
Message-ID: <511974ED.2020305@emulex.com>
Date: Mon, 11 Feb 2013 17:47:09 -0500
From: James Smart <James.Smart@emulex.com>
Reply-To: <James.Smart@emulex.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 63/77] scsi/lpfc: convert to idr_alloc()
References: <1360179649-22465-1-git-send-email-tj@kernel.org> <1360179649-22465-64-git-send-email-tj@kernel.org>
In-Reply-To: <1360179649-22465-64-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: James Smart <james.smart@emulex.com>

-- james s


On 2/6/2013 2:40 PM, Tejun Heo wrote:
> Convert to the much saner new idr interface.
>
> Only compile tested.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: James Smart <james.smart@emulex.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/scsi/lpfc/lpfc_init.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 26ca2ef..314b4f6 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -3165,14 +3165,10 @@ destroy_port(struct lpfc_vport *vport)
>   int
>   lpfc_get_instance(void)
>   {
> -	int instance = 0;
> -
> -	/* Assign an unused number */
> -	if (!idr_pre_get(&lpfc_hba_index, GFP_KERNEL))
> -		return -1;
> -	if (idr_get_new(&lpfc_hba_index, NULL, &instance))
> -		return -1;
> -	return instance;
> +	int ret;
> +
> +	ret = idr_alloc(&lpfc_hba_index, NULL, 0, 0, GFP_KERNEL);
> +	return ret < 0 ? -1 : ret;
>   }
>   
>   /**

