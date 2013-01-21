Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab3AUXKP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:10:15 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3123 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754337Ab3AUXKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:10:12 -0500
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <50FDC9B6.3040908@broadcom.com>
Date: Mon, 21 Jan 2013 15:05:26 -0800
From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615
 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Julia Lawall" <Julia.Lawall@lip6.fr>
cc: kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/15] drivers/scsi/bnx2fc/bnx2fc_io.c: adjust
 duplicate test
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
 <1358773378-4700-6-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1358773378-4700-6-git-send-email-Julia.Lawall@lip6.fr>
X-WSS-ID: 7CE3159A3R41015107-03-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 05:02 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Delete successive tests to the same location.  The code tested the result
> of a previous allocation, that itself was already tested.  It is changed to
> test the result of the most recent allocation.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @s exists@
> local idexpression y;
> expression x,e;
> @@
>
> *if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
>   { ... when forall
>     return ...; }
> ... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\)
>      when != \(XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
> *if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
>   { ... when forall
>     return ...; }
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>   drivers/scsi/bnx2fc/bnx2fc_io.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 8d4626c..8bea53d 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -654,7 +654,7 @@ int bnx2fc_init_mp_req(struct bnx2fc_cmd *io_req)
>   	mp_req->mp_resp_bd = dma_alloc_coherent(&hba->pcidev->dev, sz,
>   						 &mp_req->mp_resp_bd_dma,
>   						 GFP_ATOMIC);
> -	if (!mp_req->mp_req_bd) {
> +	if (!mp_req->mp_resp_bd) {
>   		printk(KERN_ERR PFX "unable to alloc MP resp bd\n");
>   		bnx2fc_free_mp_resc(io_req);
>   		return FAILED;
>
>
Acked-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>


