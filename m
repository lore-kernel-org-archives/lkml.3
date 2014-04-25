Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaDYOVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:21:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46481 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbaDYOU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:20:58 -0400
Date: Fri, 25 Apr 2014 07:21:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nicolas Del Piano <ndel314@gmail.com>
Cc: devel@driverdev.osuosl.org, david.daney@cavium.com,
        raluca.oncioiu91@gmail.com, linux-kernel@vger.kernel.org,
        aaro.koskinen@iki.fi
Subject: Re: [PATCH] Staging: octeon-usb: fixed a macro coding style issue
Message-ID: <20140425142133.GA14201@kroah.com>
References: <1398433702-2931-1-git-send-email-ndel314@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398433702-2931-1-git-send-email-ndel314@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 10:48:22AM -0300, Nicolas Del Piano wrote:
> Fixed a coding style error, macros with complex values should be enclosed in parentheses.
> 
> Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>
> ---
>  drivers/staging/octeon-usb/octeon-hcd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/octeon-usb/octeon-hcd.c b/drivers/staging/octeon-usb/octeon-hcd.c
> index 8b8ce72..ef3a8ce 100644
> --- a/drivers/staging/octeon-usb/octeon-hcd.c
> +++ b/drivers/staging/octeon-usb/octeon-hcd.c
> @@ -246,7 +246,7 @@ enum cvmx_usb_pipe_flags {
>  };
> 
>  /* Normal prefetch that use the pref instruction. */
> -#define CVMX_PREFETCH(address, offset) asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0))
> +#define CVMX_PREFETCH(address, offset) (asm volatile ("pref %[type], %[off](%[rbase])" : : [rbase] "d" (address), [off] "I" (offset), [type] "n" (0)))
> 
>  /* Maximum number of times to retry failed transactions */
>  #define MAX_RETRIES		3

Will that actually compile?

Why the heck are we using asm in a define in the first place?  Shouldn't
this be an inline function or something?

thanks,

greg k-h
