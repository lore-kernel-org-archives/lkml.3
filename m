Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3GYEXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 00:23:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41164 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504Ab3GYEXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 00:23:50 -0400
X-Sasl-enc: LBW47QsI10v/kWGRWd7L12WhaNYf6jL87Z59MFc1UT11 1374726229
Date: Wed, 24 Jul 2013 21:25:01 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Won Kang <wkang77@gmail.com>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20130725042501.GC7122@kroah.com>
References: <20130725131959.3c39e033c6fee01328b10119@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725131959.3c39e033c6fee01328b10119@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 01:19:59PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the staging tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/staging/gdm724x/built-in.o: In function `netlink_init':
> (.text+0x19b6): multiple definition of `netlink_init'
> drivers/staging/gdm72xx/built-in.o:(.text+0x19d5): first defined here
> drivers/staging/gdm724x/built-in.o: In function `netlink_exit':
> (.text+0x1a2a): multiple definition of `netlink_exit'
> drivers/staging/gdm72xx/built-in.o:(.text+0x1a49): first defined here
> drivers/staging/gdm724x/built-in.o: In function `netlink_send':
> (.text+0x1a4f): multiple definition of `netlink_send'
> drivers/staging/gdm72xx/built-in.o:(.text+0x1a67): first defined here
> 
> Presumably caused by commit 61e121047645 ("staging: gdm7240: adding LTE
> USB driver").  I disabled this driver using this patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 25 Jul 2013 13:16:30 +1000
> Subject: [PATCH] staging: disable the gdm724x driver due to build problems
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/staging/gdm724x/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/gdm724x/Kconfig b/drivers/staging/gdm724x/Kconfig
> index 10f7be1..85141bd 100644
> --- a/drivers/staging/gdm724x/Kconfig
> +++ b/drivers/staging/gdm724x/Kconfig
> @@ -5,6 +5,7 @@
>  config LTE_GDM724X
>  	tristate "GCT GDM724x LTE support"
>  	depends on NET && USB
> +	depends on BROKEN

Ugh, that means this can't be built into the kernel, due to symbol
issues, I'll go fix that up with a "depends on m" patch.

thanks,

greg k-h
