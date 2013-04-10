Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3DJNX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:23:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab3DJNX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:23:26 -0400
Message-ID: <516567A9.7010606@redhat.com>
Date: Wed, 10 Apr 2013 15:22:49 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: jens.axboe@kernel.dk, stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: use lun reset not target reset
References: <20130107163030.5072.17662.stgit@beardog.cce.hp.com>
In-Reply-To: <20130107163030.5072.17662.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

almost the same patch has been accepted for hpsa so

Acked-by: Tomas Henzl <thenzl@redhat.com>

On 01/07/2013 05:30 PM, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> In the scsi part of the driver (for tape drives and medium changers)
> the device reset error handler attempts to use a target reset rather
> than a lun reset.  If there is some shared tape drive library, this
> could be potentially disruptive to other hosts trying to use the
> tape library.  Use lun reset instead to only reset the lun not the
> whole target.
>
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  drivers/block/cciss.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 6526157..64d1d82 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -2632,7 +2632,7 @@ static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
>  			c->Request.Timeout = 0;
>  			memset(&c->Request.CDB[0], 0, sizeof(c->Request.CDB));
>  			c->Request.CDB[0] = cmd;	/* reset */
> -			c->Request.CDB[1] = CCISS_RESET_TYPE_TARGET;
> +			c->Request.CDB[1] = CCISS_RESET_TYPE_LUN;
>  			break;
>  		case CCISS_NOOP_MSG:
>  			c->Request.CDBLen = 1;
> @@ -2674,7 +2674,7 @@ static int __devinit cciss_send_reset(ctlr_info_t *h, unsigned char *scsi3addr,
>  		return -ENOMEM;
>  	return_status = fill_cmd(h, c, CCISS_RESET_MSG, NULL, 0, 0,
>  		CTLR_LUNID, TYPE_MSG);
> -	c->Request.CDB[1] = reset_type; /* fill_cmd defaults to target reset */
> +	c->Request.CDB[1] = reset_type; /* fill_cmd defaults to lun reset */
>  	if (return_status != IO_OK) {
>  		cmd_special_free(h, c);
>  		return return_status;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

