Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaCTBvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 21:51:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51760 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaCTBvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 21:51:41 -0400
Date: Thu, 20 Mar 2014 01:53:02 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathieu Maret <mathieu.maret@gmail.com>
Cc: pe1dnn@amsat.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/5] staging: wlags49_h2: Correct macro style in
 wl_netdev.c
Message-ID: <20140320015302.GA21123@kroah.com>
References: <1395269774-31576-1-git-send-email-mathieu.maret@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395269774-31576-1-git-send-email-mathieu.maret@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 11:56:14PM +0100, Mathieu Maret wrote:
> Multi statement macro should use do{}while(0)
> 
> patch v2 does not break compilation
> ---
>  drivers/staging/wlags49_h2/wl_netdev.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
> index 255d291..0e553ae 100644
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
> +		status = hcf_rcv_msg(&(lp->hcfCtx), desc, 0); \
> +	} while (0)

This patch is already in my tree :(

thanks,

greg k-h
