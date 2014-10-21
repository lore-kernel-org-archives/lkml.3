Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbaJUPMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:12:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33627 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbaJUPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:12:35 -0400
Date: Tue, 21 Oct 2014 18:12:28 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8712: Remove redundant cast
Message-ID: <20141021151228.GN23154@mwanda>
References: <1413903507-3256-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413903507-3256-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:58:26PM +0200, Rasmus Villemoes wrote:
> struct firmware::data has type const u8*, as does *ppmappedfw, so the
> cast to u8* is unnecessary and slightly confusing.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/staging/rtl8712/hal_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
> index 1d6ade0..cc6b390 100644
> --- a/drivers/staging/rtl8712/hal_init.c
> +++ b/drivers/staging/rtl8712/hal_init.c
> @@ -86,7 +86,7 @@ static u32 rtl871x_open_fw(struct _adapter *padapter, const u8 **ppmappedfw)
>  			(int)padapter->fw->size);
>  		return 0;
>  	}
> -	*ppmappedfw = (u8 *)((*praw)->data);
> +	*ppmappedfw = ((*praw)->data);

Remove the unneeded parens as well, please.

regards,
dan carpenter

