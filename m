Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab3ATXkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 18:40:11 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54041 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3ATXkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 18:40:09 -0500
Date: Sun, 20 Jan 2013 15:40:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/21] NTB: correct missing readq/writeq errors
Message-ID: <20130120234005.GA14196@kroah.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
 <1358586155-23322-2-git-send-email-jon.mason@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358586155-23322-2-git-send-email-jon.mason@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 02:02:15AM -0700, Jon Mason wrote:
> Atomic readq and writeq do not exist by default on some 32bit
> architectures, thus causing compile errors due to non-existent symbols.
> In those cases, use the definitions of those symbols from
> include/asm-generic/io-64-nonatomic-hi-lo.h
> 
> Signed-off-by: Jon Mason <jon.mason@intel.com>
> ---
>  drivers/ntb/ntb_hw.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> index 4c71b17..0b46fef 100644
> --- a/drivers/ntb/ntb_hw.c
> +++ b/drivers/ntb/ntb_hw.c
> @@ -45,6 +45,7 @@
>   * Contact Information:
>   * Jon Mason <jon.mason@intel.com>
>   */
> +#include <asm-generic/io-64-nonatomic-hi-lo.h>

Really?  This seems really odd.  Usually we just don't build the code
for any platform that doesn't have readq/writeq.  Otherwise, shouldn't
those arches just include this file themselves to keep everything
working?  Individual drivers shouldn't have to do this.

So, I'm not going to take this one just yet, sorry.

greg k-h
