Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab3AQQeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:34:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab3AQQeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:34:08 -0500
Date: Thu, 17 Jan 2013 18:38:07 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 64/86] drivers/vhost: remove depends on
 CONFIG_EXPERIMENTAL
Message-ID: <20130117163807.GA19315@redhat.com>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
 <1358391258-1771-65-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358391258-1771-65-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 06:53:56PM -0800, Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> CC: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

It's used in production, it's time it lost EXPERIMENTAL tag anyway.

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> ---
>  drivers/vhost/Kconfig     |    4 ++--
>  drivers/vhost/Kconfig.tcm |    4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 202bba6..bf24317 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -1,6 +1,6 @@
>  config VHOST_NET
> -	tristate "Host kernel accelerator for virtio net (EXPERIMENTAL)"
> -	depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP) && EXPERIMENTAL
> +	tristate "Host kernel accelerator for virtio net"
> +	depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP)
>  	---help---
>  	  This kernel module can be loaded in host kernel to accelerate
>  	  guest networking with virtio_net. Not to be confused with virtio_net
> diff --git a/drivers/vhost/Kconfig.tcm b/drivers/vhost/Kconfig.tcm
> index a9c6f76..7e3aa28 100644
> --- a/drivers/vhost/Kconfig.tcm
> +++ b/drivers/vhost/Kconfig.tcm
> @@ -1,6 +1,6 @@
>  config TCM_VHOST
> -	tristate "TCM_VHOST fabric module (EXPERIMENTAL)"
> -	depends on TARGET_CORE && EVENTFD && EXPERIMENTAL && m
> +	tristate "TCM_VHOST fabric module"
> +	depends on TARGET_CORE && EVENTFD && m
>  	default n
>  	---help---
>  	Say M here to enable the TCM_VHOST fabric module for use with virtio-scsi guests
> -- 
> 1.7.9.5
