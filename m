Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3FEJqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:46:12 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30363 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab3FEJqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:46:10 -0400
Date: Wed, 5 Jun 2013 12:45:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Schilling <of82ecuq@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Kurt Kanzenbach <shifty91@gmail.com>, linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>
Subject: Re: [PATCH 6/6] keucr: use more specific max_t(int, ..
Message-ID: <20130605094517.GS28112@mwanda>
References: <1370422206-14961-1-git-send-email-of82ecuq@cip.cs.fau.de>
 <1370422206-14961-7-git-send-email-of82ecuq@cip.cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370422206-14961-7-git-send-email-of82ecuq@cip.cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 10:50:06AM +0200, Johannes Schilling wrote:
> --- a/drivers/staging/keucr/transport.c
> +++ b/drivers/staging/keucr/transport.c
> @@ -708,8 +708,8 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
>  
>  		} else {
>  			residue = min(residue, transfer_length);
> -			scsi_set_resid(srb, max(scsi_get_resid(srb),
> -							(int) residue));
> +			scsi_set_resid(srb, max_t(int, scsi_get_resid(srb),
> +							(int)residue));
                                                        ^^^^^
This cast isn't needed any more when you use max_t.

regards,
dan carpenter


