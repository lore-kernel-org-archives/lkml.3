Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab3ITKoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 06:44:09 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34276 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341Ab3ITKoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 06:44:07 -0400
Date: Fri, 20 Sep 2013 13:43:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/10] staging: r8188eu: Add files for new drive: Cocci
 spatch "noderef"
Message-ID: <20130920104343.GA6192@mwanda>
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
 <1379604755853-725626372-7-diffsplit-thomas@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379604755853-725626372-7-diffsplit-thomas@m3y3r.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 11:45:46PM +0200, Thomas Meyer wrote:
> sizeof when applied to a pointer typed expression gives the size of the
> pointer.
> Found by coccinelle spatch "misc/noderef.cocci"
> 

When you're writing the changelog for these it helps if you say how
many bytes sizeof(*data) is.  In this case, we have gone from clearing 8
bytes to clearing 1 byte so the original code had a potential memory
corruption bug.

> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/staging/rtl8188eu/core/rtw_mp.c b/drivers/staging/rtl8188eu/core/rtw_mp.c
> --- a/drivers/staging/rtl8188eu/core/rtw_mp.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_mp.c
> @@ -907,7 +907,7 @@ u32 mp_query_psd(struct adapter *pAdapte
>  		sscanf(data, "pts =%d, start =%d, stop =%d", &psd_pts, &psd_start, &psd_stop);
>  	}
>  
> -	_rtw_memset(data, '\0', sizeof(data));
> +	_rtw_memset(data, '\0', sizeof(*data));

I think your fix is correct but it would be better to remove the memset
and do:

	data[0] = '\0';

"data" is a u8 pointer, but it should obviously be a char pointer.  The
original code here is not high quality.  :P

regards,
dan carpenter

