Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553AbaEFIsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:48:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19118 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934397AbaEFIsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:48:11 -0400
Date: Tue, 6 May 2014 11:47:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, burzalodowa@gmail.com,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192u: initialize array in C compliant way
Message-ID: <20140506084749.GT26890@mwanda>
References: <1399364528-3727-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399364528-3727-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 10:22:08AM +0200, Martin Kepplinger wrote:
> Don't list elements to initialize. Remaining elements of a partly
> initialized array are set to zero. Sparse complained here.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
>  drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
> index 426f223..c96dbab 100644
> --- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
> +++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
> @@ -241,7 +241,7 @@ static PTS_COMMON_INFO SearchAdmitTRStream(struct ieee80211_device *ieee,
>  {
>  	//DIRECTION_VALUE	dir;
>  	u8	dir;
> -	bool				search_dir[4] = {0, 0, 0, 0};
> +	bool				search_dir[4] = {0};

That's weird.  The original code is valid but it generates a sparse
warning.

drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c:244:58: warning: Initializer entry defined twice
drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c:244:61:   also defined here

It has something to do with "_Bool" types.  Changing it to "int" will
also make the warning disappear.  I've CC'd the sparse list to see if
anyone knows what's happening.

regards,
dan carpenter

