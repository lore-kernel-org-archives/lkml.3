Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbbAMRMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:12:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbbAMRMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:12:42 -0500
Date: Tue, 13 Jan 2015 09:12:39 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: sun wang <sun.wxg@gmail.com>
Cc: Forest@nas4free.local, Bond@nas4free.local, forest@alittletooquiet.net,
        Greg@nas4free.local, Kroah-Hartman@nas4free.local,
        guido@vanguardiasur.com.ar, Silvio@nas4free.local,
        Fricke@nas4free.local, silvio.fricke@gmail.com,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging:vt6655 Add extern variable in head file
Message-ID: <20150113171239.GA12822@kroah.com>
References: <20150113083114.GA57460@nas4free.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113083114.GA57460@nas4free.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:31:14PM +0800, sun wang wrote:
> Extern variable must be declared in head file. Compiler can catch the inconsistency when variable changes. 
> 
> Signed-off-by: Sun Wang <sun.wxg@gmail.com>
> ---
>  drivers/staging/vt6655/ioctl.c | 1 -
>  drivers/staging/vt6655/ioctl.h | 5 +++++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
> index 970e80d..716fc89 100644
> --- a/drivers/staging/vt6655/ioctl.c
> +++ b/drivers/staging/vt6655/ioctl.c
> @@ -31,7 +31,6 @@
>   */
>  
>  #include "ioctl.h"
> -#include "iocmd.h"
>  #include "mac.h"
>  #include "card.h"
>  #include "hostap.h"
> diff --git a/drivers/staging/vt6655/ioctl.h b/drivers/staging/vt6655/ioctl.h
> index 2dc5a57..42f6910 100644
> --- a/drivers/staging/vt6655/ioctl.h
> +++ b/drivers/staging/vt6655/ioctl.h
> @@ -30,6 +30,11 @@
>  #define __IOCTL_H__
>  
>  #include "device.h"
> +#include "iocmd.h"
> +
> +#ifdef WPA_SM_Transtatus
> +extern SWPAResult wpa_Result;
> +#endif

I don't understand, what problem is this solving?  This variable isn't
in the driver at all.

confused,

greg k-h
