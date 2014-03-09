Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaCIF4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 00:56:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaCIF4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 00:56:30 -0500
Date: Sat, 8 Mar 2014 21:57:06 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: linux-kernel@vger.kernel.org, Johannes Thumshirn <morbidrsa@gmail.com>
Subject: Re: [PATCH 1/2] drivers: mcb: Fix build error discovered by 0-day bot
Message-ID: <20140309055706.GA26187@kroah.com>
References: <1393879609-3284-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393879609-3284-1-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 09:46:48PM +0100, Johannes Thumshirn wrote:
> From: Johannes Thumshirn <morbidrsa@gmail.com>
> 
> Make mcb depend on HAS_IOMEM and mcb-pci depend on PCI. This fixes build errors
> discovered by the 0-day kernel build testing system.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> ---
>  drivers/mcb/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mcb/Kconfig b/drivers/mcb/Kconfig
> index b8f5d46..87d5a46 100644
> --- a/drivers/mcb/Kconfig
> +++ b/drivers/mcb/Kconfig
> @@ -4,7 +4,7 @@
>  
>  menuconfig MCB
>  	   tristate "MCB support"
> -	   default m
> +	   depends on HAS_IOMEM
>  	   help
>  
>  	   The MCB (MEN Chameleon Bus) is a Bus specific to MEN Mikroelektronik
> @@ -18,6 +18,7 @@ if MCB
>  config MCB_PCI
>  	   tristate "PCI based MCB carrier"
>  	   default m

This should not be default m either, please redo this against my latest
tree and resend.

thanks,

greg k-h
