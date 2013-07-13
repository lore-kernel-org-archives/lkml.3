Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab3GMQHU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 12:07:20 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:49756 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3GMQHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 12:07:19 -0400
Date: Sat, 13 Jul 2013 09:07:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/lustre/libcfs: fix typo "default false"
Message-ID: <20130713160716.GA2279@kroah.com>
References: <1373726446.1359.17.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373726446.1359.17.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 04:40:46PM +0200, Paul Bolle wrote:
> Commit 4b5b4c7222 ("staging/lustre/libcfs: restore LINVRNT") added
> "default false" to this Kconfig file. It was obviously meant to use
> "default n" here.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested lightly, with "make menuconfig" only.
> 
> 1) No-one noticed because "default <invalid Kconfig symbol>" and
> "default n" behave the same. Actually, it seems "default n" isn't needed
> at all. But there are hundreds of Kconfig symbols that use "default n",
> so I suppose it serves some purpose.
> 
>  drivers/staging/lustre/lustre/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
> index e0eb830..002dd2e 100644
> --- a/drivers/staging/lustre/lustre/Kconfig
> +++ b/drivers/staging/lustre/lustre/Kconfig
> @@ -43,7 +43,7 @@ config LUSTRE_OBD_MAX_IOCTL_BUFFER
>  config LUSTRE_DEBUG_EXPENSIVE_CHECK
>  	bool "Enable Lustre DEBUG checks"
>  	depends on LUSTRE_FS
> -	default false
> +	default n

Just remove it entirely, as you say, the default is 'n', so let's just
stick with that.

Care to redo this?

thanks,

greg k-h
