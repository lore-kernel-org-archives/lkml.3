Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaJBIsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:48:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42682 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaJBIsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:48:00 -0400
Date: Thu, 2 Oct 2014 11:47:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nitin Kuppelur <nitinkuppelur@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] Staging: rtl8712 removed unnecessary else after return
Message-ID: <20141002084745.GF23154@mwanda>
References: <542D013E.6030800@gmail.com>
 <1412235846-3059-1-git-send-email-nitinkuppelur@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412235846-3059-1-git-send-email-nitinkuppelur@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 09:44:06AM +0200, Nitin Kuppelur wrote:
> Removed unnecessary else after return to solve
> checkpatch.pl warning
> 
> Signed-off-by: Nitin Kuppelur <nitinkuppelur@gmail.com>
> ---
>  drivers/staging/rtl8712/hal_init.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
> index 81cd654..e5878e2 100644
> --- a/drivers/staging/rtl8712/hal_init.c
> +++ b/drivers/staging/rtl8712/hal_init.c
> @@ -387,12 +387,9 @@ uint rtl8712_hal_deinit(struct _adapter *padapter)
>  uint rtl871x_hal_init(struct _adapter *padapter)
>  {
>  	padapter->hw_init_completed = false;
> -	if (padapter->halpriv.hal_bus_init == NULL)
> +	if (padapter->halpriv.hal_bus_init == NULL ||
> +		padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
>  		return _FAIL;

Align these like this:

	if (padapter->halpriv.hal_bus_init == NULL ||
	    padapter->halpriv.hal_bus_init(padapter) != _SUCCESS) 
		return _FAIL;
[tab][space][space][space][space]padapter->halpriv.hal_bus_init...

regards,
dan carpenter

