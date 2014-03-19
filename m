Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965549AbaCSPef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:34:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965001AbaCSPed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:34:33 -0400
Date: Wed, 19 Mar 2014 08:36:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathieu Maret <mathieu.maret@gmail.com>
Cc: pe1dnn@amsat.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] staging: wlags49_h2: Correct macro style in
 wl_netdev.c
Message-ID: <20140319153637.GA19407@kroah.com>
References: <1395217235-2979-1-git-send-email-mathieu.maret@gmail.com>
 <1395217235-2979-4-git-send-email-mathieu.maret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395217235-2979-4-git-send-email-mathieu.maret@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 09:20:34AM +0100, Mathieu Maret wrote:
> Multi statement macro should use do{}while(0)
> 
> Signed-off-by: Mathieu Maret <mathieu.maret@gmail.com>
> ---
>  drivers/staging/wlags49_h2/wl_netdev.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
> index 255d291..6455956 100644
> --- a/drivers/staging/wlags49_h2/wl_netdev.c
> +++ b/drivers/staging/wlags49_h2/wl_netdev.c
> @@ -107,9 +107,11 @@
>   * macros
>   ******************************************************************************/
>  #define BLOCK_INPUT(buf, len) \
> -    desc->buf_addr = buf; \
> -    desc->BUF_SIZE = len; \
> -    status = hcf_rcv_msg(&(lp->hcfCtx), desc, 0)
> +	do { \
> +		desc->buf_addr = buf; \
> +		desc->BUF_SIZE = len; \
> +		status = hcf_rcv_msg(&(lp->hcfCtx), desc, 0) \
> +	} while (0)
>  
>  #define BLOCK_INPUT_DMA(buf, len) memcpy( buf, desc_next->buf_addr, pktlen )
>  

You didn't test-build the code after making this change, as this patch
breaks the build into lots of tiny pieces :(

Please ALWAYS test your patches.

I've applied the first 3 patches, please fix this one up (if it's even
possible, hint, I don't think it is...) and resend the remaining
patches.

thanks,

greg k-h
