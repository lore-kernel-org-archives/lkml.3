Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3GXUHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 16:07:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab3GXUHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 16:07:31 -0400
Date: Wed, 24 Jul 2013 13:07:30 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH-RESEND 3/3] staging/lustre: fix Kconfig bool defaults
Message-ID: <20130724200730.GA22161@kroah.com>
References: <1374689299-10126-1-git-send-email-bergwolf@gmail.com>
 <1374689299-10126-4-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374689299-10126-4-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 02:08:19AM +0800, Peng Tao wrote:
> From: Peng Tao <tao.peng@emc.com>
> 
> Should be y instead of true.
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>
> Cc: Andreas Dilger <andreas.dilger@intel.com>
> Signed-off-by: Peng Tao <tao.peng@emc.com>
> ---
>  drivers/staging/lustre/lustre/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
> index 9ae7fa8..e3b3c74 100644
> --- a/drivers/staging/lustre/lustre/Kconfig
> +++ b/drivers/staging/lustre/lustre/Kconfig
> @@ -52,4 +52,4 @@ config LUSTRE_DEBUG_EXPENSIVE_CHECK
>  config LUSTRE_TRANSLATE_ERRNOS
>  	bool
>  	depends on LUSTRE_FS && !X86
> -	default true
> +	default y

Why is the default for this going to be 'y'?  That should only be for
things that keep the machine from booting.

If this is something you always want to do, then why make it an option
at all?

Given that there is no documentation for what this option is, and why
people should always turn it on, I can't accept this patch, sorry.

greg k-h
