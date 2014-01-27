Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaA0JL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:11:56 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:39979 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaA0JLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:11:54 -0500
Subject: Re: [PATCH] misc: genwqe: Fix potential memory leak when pinning
 memory
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Christian Engelmayer <cengelma@gmx.at>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, haver@linux.vnet.ibm.com
In-Reply-To: <20140125224744.0a9c360c@spike>
References: <20140125224744.0a9c360c@spike>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 27 Jan 2014 10:11:44 +0100
Message-ID: <1390813904.18801.2.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012709-2966-0000-0000-00000A0CFDB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

Am Samstag, den 25.01.2014, 22:47 +0100 schrieb Christian Engelmayer:
> Fix a memory leak in the genwqe_pin_mem() error path as called by
> ioctl GENWQE_PIN_MEM. In case there is an error encountered when
> mapping memory, the already allocated dma_mapping struct needs to
> be freed correctly.
> 
> Detected by Coverity: CID 1162606.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
>  drivers/misc/genwqe/card_dev.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/misc/genwqe/card_dev.c b/drivers/misc/genwqe/card_dev.c
> index 8f8a6b3..2c2c9cc 100644
> --- a/drivers/misc/genwqe/card_dev.c
> +++ b/drivers/misc/genwqe/card_dev.c
> @@ -787,6 +787,7 @@ static int genwqe_pin_mem(struct genwqe_file *cfile, struct genwqe_mem *m)
>  	if (rc != 0) {
>  		dev_err(&pci_dev->dev,
>  			"[%s] genwqe_user_vmap rc=%d\n", __func__, rc);
> +		kfree(dma_map);
>  		return rc;
>  	}
> 

thanks for discovering and fixing the problem.

Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>

