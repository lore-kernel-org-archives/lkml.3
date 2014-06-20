Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965847AbaFTJJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 05:09:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18562 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026AbaFTJJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 05:09:51 -0400
Date: Fri, 20 Jun 2014 12:09:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgap: make dgap_found_board() return a brd
 pointer
Message-ID: <20140620090937.GS5500@mwanda>
References: <20140620051958.GA17076@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620051958.GA17076@devel.8.8.4.4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:19:58PM +0900, Daeseok Youn wrote:
> -	rc = dgap_found_board(pdev, ent->driver_data, dgap_numboards);
> -	if (rc)
> +	brd = dgap_found_board(pdev, ent->driver_data, dgap_numboards);
> +	if (IS_ERR(brd))
>  		return rc;

		return ERR_PTR(brd);


>  
> -	brd = dgap_board[dgap_numboards++];
>  	rc = dgap_firmware_load(pdev, ent->driver_data, brd);
>  	if (rc)
>  		goto cleanup_brd;
> @@ -617,6 +617,8 @@ static int dgap_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	brd->state = BOARD_READY;
>  	brd->dpastatus = BD_RUNNING;
>  
> +	dgap_board[dgap_numboards++] = brd;

You need to update the error handling of this function to remove the
reference do dgap_board[] as well.

> +
>  	return 0;
>  

regards,
dan carpenter

