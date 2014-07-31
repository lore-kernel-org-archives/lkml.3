Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaGaAJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:09:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaGaAJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:09:23 -0400
Date: Wed, 30 Jul 2014 17:08:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anil Belur <askb23@gmail.com>
Cc: tklauser@distanz.ch, dan.carpenter@oracle.com, bjorn@mork.no,
        silvio.fricke@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: vt6655: ioctl.c - missing __user annotation
Message-ID: <20140731000854.GA8934@kroah.com>
References: <1406725197-18530-1-git-send-email-askb23@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406725197-18530-1-git-send-email-askb23@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 06:29:57PM +0530, Anil Belur wrote:
> - private_ioctl() internally calls copy_{to,from}_user() and does
>   not use '__user' which gives out several sparse warnings
> - these sparse warnings were fixed by adding __user annotation to
>   the data member of struct tagSCmdRequest:
> 
>  drivers/staging/vt6655/ioctl.c:78:51: warning: incorrect type in argument 2 (different address spaces)
>  drivers/staging/vt6655/ioctl.c:78:51:    expected void const [noderef] asn:1>*from
>  drivers/staging/vt6655/ioctl.c:78:51:    got void *data
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>
> ---
> v2:
> - replaced the 'void __user *' casts by adding '__user' annotation to the data member of struct
>   tagSCmdRequest which is much cleaner approach as suggested by tklauser@distanz.ch
> v1:
> - added 'void __user *' casts to supress the warnings
> 
>  drivers/staging/vt6655/iocmd.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6655/iocmd.h b/drivers/staging/vt6655/iocmd.h
> index e499f1b..dd12498 100644
> --- a/drivers/staging/vt6655/iocmd.h
> +++ b/drivers/staging/vt6655/iocmd.h
> @@ -100,7 +100,7 @@ typedef enum tagWZONETYPE {
>  #pragma pack(1)
>  typedef struct tagSCmdRequest {
>  	u8	    name[16];
> -	void	*data;
> +	void __user *data;
>  	u16	    wResult;
>  	u16     wCmdCode;
>  } SCmdRequest, *PSCmdRequest;

This patch doesn't apply against my tree at all, what did you make it
against?

Always work against linux-next, or the staging-next branch of my
staging.git tree on git.kernel.org.

thanks,

greg k-h
