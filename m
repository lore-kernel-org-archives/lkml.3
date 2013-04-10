Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936911Ab3DJPuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:50:04 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53314 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3DJPuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:50:02 -0400
Date: Wed, 10 Apr 2013 08:49:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Add additional distro specific
 Kconfig options
Message-ID: <20130410154957.GA13849@kroah.com>
References: <1365610097-10955-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365610097-10955-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 09:08:17AM -0700, K. Y. Srinivasan wrote:
> The guest ID captures information about the guest and has room for
> distributions to add distro specific information. Add Kconfig options
> to support distro specific information to be managed easily.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/Kconfig        |   14 ++++++++++++++
>  drivers/hv/hv.c           |    4 +++-
>  drivers/hv/hyperv_vmbus.h |    2 +-
>  3 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
> index 0403b51..d2ca9c7 100644
> --- a/drivers/hv/Kconfig
> +++ b/drivers/hv/Kconfig
> @@ -19,4 +19,18 @@ config HYPERV_BALLOON
>  	help
>  	  Select this option to enable Hyper-V Balloon driver.
>  
> +config HYPERV_GUEST_D1
> +	hex "Distro specific information"
> +	range 0x00 0xff
> +	default 0
> +	help
> +	  This specifies the Distro vendor

And just what is a distro supposed to set the value here to?  For
example, what would Arch Linux pick?  Fedora?  RHEL?  SLES?  openSUSE?
You do know that there are more than 0xff different Linux distro
"vendors"?  Do they all just get to pick a number that they like?

> +config HYPERV_GUEST_D2
> +	hex "Additional Distro specific information"
> +	range 0x0000 0xffff
> +	default 0
> +	help
> +	  Additional Distro specific kernel version information

Again, what is a distro supposed to do here?  What's wrong with the
kernel version information that the kernel already has?  Can't you just
use that string?

greg k-h
