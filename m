Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756832AbaGVURY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:17:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaGVURX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:17:23 -0400
Date: Tue, 22 Jul 2014 13:17:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeff Oczek <jeffoczek@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: cxt1e1: Fix static symbol sparse warnings for
 global vars in linux.c
Message-ID: <20140722201722.GA20515@kroah.com>
References: <1406059671-6536-1-git-send-email-jeffoczek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406059671-6536-1-git-send-email-jeffoczek@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 04:07:51PM -0400, Jeff Oczek wrote:
> Put extern declarations in cxt1e1_common.h to reduce sparse warnings for linux.c:
> drivers/staging/cxt1e1/linux.c:86:13: warning:
>   symbol 'error_flag' was not declared. Should it be static?
> drivers/staging/cxt1e1/linux.c:91:13: warning:
>   symbol 'cxt1e1_max_mru' was not declared. Should it be static?
> drivers/staging/cxt1e1/linux.c:95:13: warning:
>   symbol 'cxt1e1_max_mtu' was not declared. Should it be static?
> drivers/staging/cxt1e1/linux.c:96:13: warning:
>   symbol 'max_mtu_default' was not declared. Should it be static?
> drivers/staging/cxt1e1/linux.c:99:13: warning:
>   symbol 'max_txdesc_used' was not declared. Should it be static?
> drivers/staging/cxt1e1/linux.c:100:13: warning:
>   symbol 'max_txd:esc_default' was not declared. Should it be static?
> drivers/staging/cxt1e1/linux.c:103:13: warning:
>   symbol 'max_rxdesc_used' was not declared. Should it be static?
> drivers/staging/cxt1e1/linux.c:104:13: warning:
>   symbol 'max_rxdesc_default' was not declared. Should it be static?
> drivers/staging/cxt1e1/linux.c:153:1: warning:
>   symbol 'c4_wk_chan_restart' was not declared. Should it be static?
> drivers/staging/cxt1e1/linux.c:171:1: warning:
>   symbol 'c4_wk_chan_init' was not declared. Should it be static?
> drivers/staging/cxt1e1/linux.c:186:1: warning:
>   symbol 'c4_wq_port_init' was not declared. Should it be static?
> drivers/staging/cxt1e1/linux.c:208:1: warning:
>   symbol 'c4_wq_port_cleanup' was not declared. Should it be static?
> 
> Signed-off-by: Jeff Oczek <jeffoczek@gmail.com>
> ---
>  drivers/staging/cxt1e1/cxt1e1_common.h | 15 +++++++++++++++
>  drivers/staging/cxt1e1/hwprobe.c       |  2 +-
>  drivers/staging/cxt1e1/linux.c         |  2 +-
>  drivers/staging/cxt1e1/musycc.c        |  7 +------
>  drivers/staging/cxt1e1/pmcc4_drv.c     |  5 +----
>  5 files changed, 19 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/staging/cxt1e1/cxt1e1_common.h
> 
> diff --git a/drivers/staging/cxt1e1/cxt1e1_common.h b/drivers/staging/cxt1e1/cxt1e1_common.h
> new file mode 100644
> index 0000000..ac6b974
> --- /dev/null
> +++ b/drivers/staging/cxt1e1/cxt1e1_common.h
> @@ -0,0 +1,15 @@
> +#ifndef __CXT1E1_COMMON_H
> +#define __CXT1E1_COMMON_H
> +
> +#include "pmcc4.h"
> +
> +extern int error_flag;

I know you didn't name this variable, but wow, that's a horrid name for
a global variable :)

Any way you could change this to first fix up the name of the variable
to something a bit more "device-specific" first, before this patch?

Perhaps "cxt1e1_error_flag"?

> +extern int cxt1e1_max_mru;
> +extern int cxt1e1_max_mtu;

These are fine.

> +extern int max_mtu_default;
> +extern int max_txdesc_used;
> +extern int max_txdesc_default;
> +extern int max_rxdesc_used;
> +extern int max_rxdesc_default;

Again, these are bad names, can you do the same thing here?

thanks,

greg k-h
