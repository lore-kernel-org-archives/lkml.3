Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab3ITKpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 06:45:20 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34617 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3ITKpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 06:45:19 -0400
Date: Fri, 20 Sep 2013 13:44:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/10] staging: r8188eu: Cocci spatch "noderef"
Message-ID: <20130920104457.GB6192@mwanda>
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
 <1379604755854-737294623-9-diffsplit-thomas@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379604755854-737294623-9-diffsplit-thomas@m3y3r.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 11:45:46PM +0200, Thomas Meyer wrote:
> sizeof when applied to a pointer typed expression gives the size of the
> pointer.
> Found by coccinelle spatch "misc/noderef.cocci"
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
> --- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
> +++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
> @@ -6973,7 +6973,7 @@ static int rtw_mp_ctx(struct net_device
>  	stop = strncmp(extra, "stop", 4);
>  	sscanf(extra, "count =%d, pkt", &count);
>  
> -	_rtw_memset(extra, '\0', sizeof(extra));
> +	_rtw_memset(extra, '\0', sizeof(*extra));

Do:

	extra[0] = '\0';

regards,
dan carpenter

