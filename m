Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906Ab3GGA2w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 20:28:52 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:60772 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3GGA2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 20:28:49 -0400
Message-ID: <1373157227.7397.74.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 2/3] target: remove unused codes from enum
 tcm_tmrsp_table
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, target-devel <target-devel@vger.kernel.org>
Date: Sat, 06 Jul 2013 17:33:47 -0700
In-Reply-To: <1372864937-32437-3-git-send-email-joern@logfs.org>
References: <1372864937-32437-1-git-send-email-joern@logfs.org>
	 <1372864937-32437-3-git-send-email-joern@logfs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-03 at 11:22 -0400, Joern Engel wrote:
> Three have been checked for but were never set.  Remove the dead code.
> Also renumbers the remaining ones to a) get rid of the holes after the
> removal and b) avoid a collision between TMR_FUNCTION_COMPLETE==0 and
> the uninitialized case.  If we failed to set a code, we should rather
> fall into the default case then return success.
> 
> Signed-off-by: Joern Engel <joern@logfs.org>
> ---

Appled to for-next.

Thanks Joern!

--nab

>  drivers/target/iscsi/iscsi_target.c |    2 --
>  drivers/target/tcm_fc/tfc_cmd.c     |    3 ---
>  include/target/target_core_base.h   |   13 +++++--------
>  3 files changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 49346b3..25d5567 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -3136,8 +3136,6 @@ static u8 iscsit_convert_tcm_tmr_rsp(struct se_tmr_req *se_tmr)
>  		return ISCSI_TMF_RSP_NO_LUN;
>  	case TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED:
>  		return ISCSI_TMF_RSP_NOT_SUPPORTED;
> -	case TMR_FUNCTION_AUTHORIZATION_FAILED:
> -		return ISCSI_TMF_RSP_AUTH_FAILED;
>  	case TMR_FUNCTION_REJECTED:
>  	default:
>  		return ISCSI_TMF_RSP_REJECTED;
> diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
> index b406f17..7b6bb72 100644
> --- a/drivers/target/tcm_fc/tfc_cmd.c
> +++ b/drivers/target/tcm_fc/tfc_cmd.c
> @@ -413,10 +413,7 @@ int ft_queue_tm_resp(struct se_cmd *se_cmd)
>  		code = FCP_TMF_REJECTED;
>  		break;
>  	case TMR_TASK_DOES_NOT_EXIST:
> -	case TMR_TASK_STILL_ALLEGIANT:
> -	case TMR_TASK_FAILOVER_NOT_SUPPORTED:
>  	case TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED:
> -	case TMR_FUNCTION_AUTHORIZATION_FAILED:
>  	default:
>  		code = FCP_TMF_FAILED;
>  		break;
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index c4af592..4e7dd74 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -218,14 +218,11 @@ enum tcm_tmreq_table {
>  
>  /* fabric independent task management response values */
>  enum tcm_tmrsp_table {
> -	TMR_FUNCTION_COMPLETE		= 0,
> -	TMR_TASK_DOES_NOT_EXIST		= 1,
> -	TMR_LUN_DOES_NOT_EXIST		= 2,
> -	TMR_TASK_STILL_ALLEGIANT	= 3,
> -	TMR_TASK_FAILOVER_NOT_SUPPORTED	= 4,
> -	TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED	= 5,
> -	TMR_FUNCTION_AUTHORIZATION_FAILED = 6,
> -	TMR_FUNCTION_REJECTED		= 255,
> +	TMR_FUNCTION_COMPLETE		= 1,
> +	TMR_TASK_DOES_NOT_EXIST		= 2,
> +	TMR_LUN_DOES_NOT_EXIST		= 3,
> +	TMR_TASK_MGMT_FUNCTION_NOT_SUPPORTED	= 4,
> +	TMR_FUNCTION_REJECTED		= 5,
>  };
>  
>  /*


