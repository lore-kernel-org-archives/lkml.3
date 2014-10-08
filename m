Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaJHWoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:44:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaJHWoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:44:14 -0400
Date: Wed, 8 Oct 2014 15:44:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nitin Kuppelur <nitinkuppelur@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] Staging: rtl8712 removed unnecessary else after return
Message-ID: <20141008224414.GA25262@kroah.com>
References: <20141002084745.GF23154@mwanda>
 <1412253146-3568-1-git-send-email-nitinkuppelur@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412253146-3568-1-git-send-email-nitinkuppelur@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 02:32:26PM +0200, Nitin Kuppelur wrote:
> Removed unnecessary else after return to solve
> checkpatch.pl warning
> 
> Signed-off-by: Nitin Kuppelur <nitinkuppelur@gmail.com>
> ---
>  drivers/staging/rtl8712/hal_init.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
> index 81cd654..fbaba11 100644
> --- a/drivers/staging/rtl8712/hal_init.c
> +++ b/drivers/staging/rtl8712/hal_init.c
> @@ -387,12 +387,9 @@ uint rtl8712_hal_deinit(struct _adapter *padapter)
>  uint rtl871x_hal_init(struct _adapter *padapter)
>  {
>  	padapter->hw_init_completed = false;
> -	if (padapter->halpriv.hal_bus_init == NULL)
> +	if (padapter->halpriv.hal_bus_init == NULL ||
> +	    padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
>  		return _FAIL;
> -	else {
> -		if (padapter->halpriv.hal_bus_init(padapter) != _SUCCESS)
> -			return _FAIL;
> -	}
>  	if (rtl8712_hal_init(padapter) == _SUCCESS)
>  		padapter->hw_init_completed = true;
>  	else {

This doesn't apply to my tree :(
