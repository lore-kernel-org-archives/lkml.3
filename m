Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3HES5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:57:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33302 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3HES5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:57:06 -0400
Date: Mon, 5 Aug 2013 21:56:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] staging: ozwpan: Return correct hub status.
Message-ID: <20130805185643.GM5051@mwanda>
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
 <1375724415-10801-5-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375724415-10801-5-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 06:40:15PM +0100, Rupesh Gujare wrote:
> Fix a bug where we were not returning correct hub status
> for 8th port.

What are the user visible effects of this bug?

Style nits below.

> 
> Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
> ---
>  drivers/staging/ozwpan/ozhcd.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
> index b060e43..2f93a00 100644
> --- a/drivers/staging/ozwpan/ozhcd.c
> +++ b/drivers/staging/ozwpan/ozhcd.c
> @@ -1871,17 +1871,24 @@ static int oz_hcd_hub_status_data(struct usb_hcd *hcd, char *buf)
>  	int i;
>  
>  	buf[0] = 0;
> +	buf[1] = 0;
>  
>  	spin_lock_bh(&ozhcd->hcd_lock);
>  	for (i = 0; i < OZ_NB_PORTS; i++) {
>  		if (ozhcd->ports[i].flags & OZ_PORT_F_CHANGED) {
>  			oz_dbg(HUB, "Port %d changed\n", i);
>  			ozhcd->ports[i].flags &= ~OZ_PORT_F_CHANGED;
> -			buf[0] |= 1<<(i+1);
> +			if (i < 7)
> +				buf[0] |= 1 << (i+1);

Put spaces around math operations:
				buf[0] |= 1 << (i + 1);

> +			else
> +				buf[1] |= 1 << (i-7);

				buf[1] |= 1 << (i - 7);

regards,
dan carpenter

