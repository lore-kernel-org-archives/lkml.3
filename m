Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaKKEYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 23:24:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaKKEYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 23:24:34 -0500
Date: Tue, 11 Nov 2014 13:23:15 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [V2 PATCH 10/10] added kernel build, configuration, and TODO
 files
Message-ID: <20141111042315.GC22068@kroah.com>
References: <1415671781-11351-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415671781-11351-10-git-send-email-stephanie.s.wallick@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415671781-11351-10-git-send-email-stephanie.s.wallick@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 06:09:41PM -0800, Stephanie Wallick wrote:
> Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
> Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>

No changelog entry?


> ---
>  MAINTAINERS                            |  7 +++++++
>  drivers/staging/Kconfig                |  2 ++
>  drivers/staging/Makefile               |  1 +
>  drivers/staging/mausb/Kconfig          | 16 ++++++++++++++++
>  drivers/staging/mausb/Makefile         |  2 ++
>  drivers/staging/mausb/TODO             |  5 +++++
>  drivers/staging/mausb/drivers/Kconfig  | 34 ++++++++++++++++++++++++++++++++++
>  drivers/staging/mausb/drivers/Makefile | 18 ++++++++++++++++++
>  8 files changed, 85 insertions(+)
>  create mode 100644 drivers/staging/mausb/Kconfig
>  create mode 100644 drivers/staging/mausb/Makefile
>  create mode 100644 drivers/staging/mausb/TODO
>  create mode 100644 drivers/staging/mausb/drivers/Kconfig
>  create mode 100644 drivers/staging/mausb/drivers/Makefile
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c3cfa1b..bd52ec2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8721,6 +8721,13 @@ W:	http://www.lirc.org/
>  S:	Odd Fixes
>  F:	drivers/staging/media/lirc/
>  
> +STAGING - MEDIA AGNOSTIC USB DRIVERS
> +M:	Sean O. Stalley <sean.stalley@intel.com>
> +M:	Stephanie Wallick <stephanie.s.wallick@intel.com>
> +L:	linux-usb@vger.kernel.org
> +S:	Maintained
> +F:	drivers/staging/mausb
> +
>  STAGING - NVIDIA COMPLIANT EMBEDDED CONTROLLER INTERFACE (nvec)
>  M:	Julian Andres Klode <jak@jak-linux.org>
>  M:	Marc Dietrich <marvin24@gmx.de>
> diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
> index 35b494f..f57621b 100644
> --- a/drivers/staging/Kconfig
> +++ b/drivers/staging/Kconfig
> @@ -24,6 +24,8 @@ menuconfig STAGING
>  
>  if STAGING
>  
> +source "drivers/staging/mausb/Kconfig"
> +
>  source "drivers/staging/et131x/Kconfig"
>  
>  source "drivers/staging/slicoss/Kconfig"

Please put yourself at the end, not the top of this file.
> --- /dev/null
> +++ b/drivers/staging/mausb/TODO
> @@ -0,0 +1,5 @@
> +TODO:
> +	- checkpatch.pl cleanups
> +	- address miscellaneous "TODO" statements in code
> +	- add support for multiple media agnostic (MA) devices
> +	- add/improve support for unimplemented packet types

What about the other comments you already received such as:
	- unify with usbip



> diff --git a/drivers/staging/mausb/drivers/Kconfig b/drivers/staging/mausb/drivers/Kconfig
> new file mode 100644
> index 0000000..9e12e22
> --- /dev/null
> +++ b/drivers/staging/mausb/drivers/Kconfig
> @@ -0,0 +1,34 @@
> +config MA_CORE
> +	tristate "MA USB core"
> +	---help---
> +	  This builds ma_core module.
> +
> +config MAUSB_HOST
> +	tristate "MA USB host"
> +	depends on MA_CORE
> +	---help---
> +	  This builds MA USB host driver module.
> +
> +config MAUSB_DEVICE
> +	tristate "MA USB device"
> +	depends on MA_CORE && USB_GADGET
> +	---help---
> +	  This builds MA USB device driver module.
> +
> +config MATCP_CORE
> +	tristate "MA USB tcp core"
> +	---help---
> +	  This builds tcp_core module.
> +
> +config MATCP_HOST
> +	tristate "MA USB host tcp"
> +	depends on MATCP_CORE
> +	---help---
> +	  This builds tcp_host module.
> +
> +config MATCP_DEVICE
> +	tristate "MA USB device tcp"
> +	depends on MATCP_CORE
> +	---help---
> +	  This builds tcp_dev module.
> +
> diff --git a/drivers/staging/mausb/drivers/Makefile b/drivers/staging/mausb/drivers/Makefile
> new file mode 100644
> index 0000000..47f3222
> --- /dev/null
> +++ b/drivers/staging/mausb/drivers/Makefile
> @@ -0,0 +1,18 @@
> +obj-$(CONFIG_MA_CORE) += ma_core.o
> +ma_core-y := mausb_pkt.o mausb_tx.o mausb_msapi.o mausb_mem.o mausb_mgmt.o
> +
> +obj-$(CONFIG_MAUSB_HOST) += mausb.o
> +mausb-y := mausb_hcd.o mausb_hub.o mausb_tx-host.o mausb_mem-host.o
> +
> +obj-$(CONFIG_MAUSB_DEVICE) += maudc.o
> +maudc-y := mausb_udc.o mausb_tx-device.o
> +
> +obj-$(CONFIG_MATCP_HOST) += matcp_host.o
> +matcp_host-y := mausb_tcp-host.o
> +
> +obj-$(CONFIG_MATCP_DEVICE) += matcp_dev.o
> +matcp_dev-y := mausb_tcp-device.o
> +
> +obj-$(CONFIG_MATCP_CORE) += matcp_core.o
> +matcp_core-y := mausb_tcp.o mausb_ioctl.o

Why so many different modules?  Can't you merge most of these together
as you can't do anything with just a few of them alone.

thanks,

greg k-h
