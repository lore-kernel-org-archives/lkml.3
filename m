Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbaA0Wxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:53:32 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21039 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876AbaA0Wxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:53:31 -0500
Date: Tue, 28 Jan 2014 01:52:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: xypron.glpk@gmx.de
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, ly80toro@cip.cs.fau.de,
        linux-kernel@vger.kernel.org, ke42caxa@cip.cs.fau.de
Subject: Re: [PATCH 1/1] usbip/userspace/libsrc/names.c: memory leak
Message-ID: <20140127225247.GG7444@mwanda>
References: <1390861789-8981-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390861789-8981-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 11:29:48PM +0100, xypron.glpk@gmx.de wrote:
> From: Heinrich Schuchardt <xypron.glpk@gmx.de>

Fix your email account so we can get this automatically from your email.
Currently the From header on your email is just:

From: xypron.glpk@gmx.de

without your name.

> 
> p is freed if NULL.
> p is leaked if second calloc fails.
> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  drivers/staging/usbip/userspace/libsrc/names.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/usbip/userspace/libsrc/names.c b/drivers/staging/usbip/userspace/libsrc/names.c
> index 3c8d28b..b2904e8 100644
> --- a/drivers/staging/usbip/userspace/libsrc/names.c
> +++ b/drivers/staging/usbip/userspace/libsrc/names.c
> @@ -170,12 +170,12 @@ static void *my_malloc(size_t size)
>  
>  	p = calloc(1, sizeof(struct pool));
>  	if (!p) {
> -		free(p);
>  		return NULL;
>  	}

Remove the curly braces from here since they are no longer needed.

>  
>  	p->mem = calloc(1, size);
>  	if (!p->mem)
> +		free(p);
>  		return NULL;

Add the curly braces here.  They are required.

regards,
dan carpenter

