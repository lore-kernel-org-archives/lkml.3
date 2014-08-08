Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbaHHOih (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:38:37 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:4896 "EHLO mx01-fr.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134AbaHHOic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:38:32 -0400
Message-ID: <53E4E0DD.2020901@bfs.de>
Date: Fri, 08 Aug 2014 16:38:21 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Adaptec OEM Raid Solutions <aacraid@adaptec.com>,
        kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com
Subject: Re: [PATCH 1/1] dpt_i2o: delete unnecessary null test on array
References: <1407321551-27479-1-git-send-email-Julia.Lawall@lip6.fr> <1407321551-27479-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1407321551-27479-2-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 06.08.2014 12:39, schrieb Julia Lawall:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete NULL test on array (always false).
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> type T;
> T [] e;
> position p;
> @@
> e ==@p NULL
> 
> @ disable fld_to_ptr@
> expression e;
> identifier f;
> position r.p;
> @@
> * e.f ==@p NULL
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
> I don't know if this is the correct change, or if some other test was
> intended.  But the code has been this way since at least 2.4.20, so it
> would seem that no one has been bothered by the lack of whatever this was
> supposed to test for.
> 
>  drivers/scsi/dpt_i2o.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
> index 67283ef..62e276b 100644
> --- a/drivers/scsi/dpt_i2o.c
> +++ b/drivers/scsi/dpt_i2o.c
> @@ -1169,11 +1169,6 @@ static struct adpt_device* adpt_find_device(adpt_hba* pHba, u32 chan, u32 id, u6
>  	if(chan < 0 || chan >= MAX_CHANNEL)
>  		return NULL;
>  	

chan is u32 and u32 < 0 ?
for the next round.

re,
 wh

> -	if( pHba->channel[chan].device == NULL){
> -		printk(KERN_DEBUG"Adaptec I2O RAID: Trying to find device before they are allocated\n");
> -		return NULL;
> -	}
> -
>  	d = pHba->channel[chan].device[id];
>  	if(!d || d->tid == 0) {
>  		return NULL;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
