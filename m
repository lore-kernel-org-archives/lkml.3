Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaHDLQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:16:51 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:53598 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaHDLQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:16:50 -0400
Date: Mon, 4 Aug 2014 07:16:38 -0400
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Hans Wennborg <hans@hanshq.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/19] drivers: atm: fix %d confusingly prefixed with 0x
 in format strings
Message-ID: <20140804071638.32fd85ed@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <1407111500-14547-1-git-send-email-hans@hanshq.net>
References: <1407111500-14547-1-git-send-email-hans@hanshq.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=-0.001
X-NRLCMF-Virus-Scanned: No virus found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Chas Williams <chas@cmf.nrl.navy.mil>

On Sun,  3 Aug 2014 17:18:20 -0700
Hans Wennborg <hans@hanshq.net> wrote:

> Signed-off-by: Hans Wennborg <hans@hanshq.net>
> ---
>  drivers/atm/eni.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
> index b1955ba..d65975a 100644
> --- a/drivers/atm/eni.c
> +++ b/drivers/atm/eni.c
> @@ -2155,7 +2155,7 @@ static int eni_proc_read(struct atm_dev *dev,loff_t *pos,char *page)
>  
>  		if (!tx->send) continue;
>  		if (!--left) {
> -			return sprintf(page,"tx[%d]:    0x%ld-0x%ld "
> +			return sprintf(page, "tx[%d]:    0x%lx-0x%lx "
>  			    "(%6ld bytes), rsv %d cps, shp %d cps%s\n",i,
>  			    (unsigned long) (tx->send - eni_dev->ram),
>  			    tx->send-eni_dev->ram+tx->words*4-1,tx->words*4,
> @@ -2181,7 +2181,7 @@ static int eni_proc_read(struct atm_dev *dev,loff_t *pos,char *page)
>  			if (--left) continue;
>  			length = sprintf(page,"vcc %4d: ",vcc->vci);
>  			if (eni_vcc->rx) {
> -				length += sprintf(page+length,"0x%ld-0x%ld "
> +				length += sprintf(page+length, "0x%lx-0x%lx "
>  				    "(%6ld bytes)",
>  				    (unsigned long) (eni_vcc->recv - eni_dev->ram),
>  				    eni_vcc->recv-eni_dev->ram+eni_vcc->words*4-1,

