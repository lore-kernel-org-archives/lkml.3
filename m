Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaBTUPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:15:05 -0500
Received: from relay2.sgi.com ([192.48.179.30]:37699 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752817AbaBTUPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:15:03 -0500
Date: Thu, 20 Feb 2014 14:14:58 -0600
From: Russ Anderson <rja@sgi.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: minyard@acm.org, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] Change ACPI IPMI support to "default y"
Message-ID: <20140220201458.GA7099@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392740909-2079-1-git-send-email-matthew.garrett@nebula.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 11:28:29AM -0500, Matthew Garrett wrote:
> The ACPI IPMI driver implements IPMI operation region support for the ACPI
> core. Systems that declare ACPI operation regions may reference them at any
> time, including during kernel initialisation. These accesses will fail
> unless the ACPI IPMI driver is present, and undesirable system behaviour
> may result. Set the default to Y in order to encourage distributions and
> users to configure kernels to avoid awkward surprises.

No, please do not build the ipmi_si driver into the kernel.
Not all systems want, or need, the ipmi_si driver.  

The distro that added this change created all sorts of support
problems.  Problems include kipmi0 spinning at 100% of cpu
(creating a performance hit) and long boot delays (as the
kernel tries to talk to a BMC that will never respond).
It has been a big mess.

Nacked-by: Russ Anderson <rja@sgi.com>


> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
> Actually, I guess we also want this on CONFIG_IPMI_HANDLER for least
> surprise
> 
>  drivers/acpi/Kconfig      | 2 +-
>  drivers/char/ipmi/Kconfig | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 4770de5..0e6aab9 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -162,7 +162,7 @@ config ACPI_PROCESSOR
>  config ACPI_IPMI
>  	tristate "IPMI"
>  	depends on IPMI_SI
> -	default n
> +	default y
>  	help
>  	  This driver enables the ACPI to access the BMC controller. And it
>  	  uses the IPMI request/response message to communicate with BMC
> diff --git a/drivers/char/ipmi/Kconfig b/drivers/char/ipmi/Kconfig
> index 0baa8fa..eea8464 100644
> --- a/drivers/char/ipmi/Kconfig
> +++ b/drivers/char/ipmi/Kconfig
> @@ -5,6 +5,7 @@
>  menuconfig IPMI_HANDLER
>         tristate 'IPMI top-level message handler'
>         depends on HAS_IOMEM
> +       default y if ACPI
>         help
>           This enables the central IPMI message handler, required for IPMI
>  	 to work.
> @@ -45,6 +46,7 @@ config IPMI_DEVICE_INTERFACE
>  
>  config IPMI_SI
>         tristate 'IPMI System Interface handler'
> +       default y if ACPI
>         help
>           Provides a driver for System Interfaces (KCS, SMIC, BT).
>  	 Currently, only KCS and SMIC are supported.  If
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
