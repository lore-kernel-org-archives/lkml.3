Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbaFYO0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:26:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757236AbaFYO0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:26:43 -0400
Message-ID: <53AADC16.9080301@redhat.com>
Date: Wed, 25 Jun 2014 16:26:30 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Eddie Wai <eddie.wai@broadcom.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2i: bnx2i_iscsi.c:  Cleaning up variable is
 set more than once
References: <1403705059-25834-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1403705059-25834-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/25/2014 04:04 PM, Rickard Strandqvist wrote:
> A struct member variable is set to different values without having used in between.
> 
> This was found using a static code analysis program called cppcheck
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/scsi/bnx2i/bnx2i_iscsi.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index 166543f..fdf7bc3 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1643,7 +1643,6 @@ static void bnx2i_conn_get_stats(struct iscsi_cls_conn *cls_conn,
>  	stats->r2t_pdus = conn->r2t_pdus_cnt;
>  	stats->tmfcmd_pdus = conn->tmfcmd_pdus_cnt;
>  	stats->tmfrsp_pdus = conn->tmfrsp_pdus_cnt;
> -	stats->custom_length = 3;
>  	strcpy(stats->custom[2].desc, "eh_abort_cnt");
>  	stats->custom[2].value = conn->eh_abort_cnt;
>  	stats->digest_err = 0;
> 

Eddie,

The code modifies the content of stats->custom[2], so shouldn't custom_length be set to 3?
Why is it set to zero at the end of this function?

Regards,
Maurizio Lombardi
