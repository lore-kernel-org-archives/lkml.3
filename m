Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab3CHUft (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:35:49 -0500
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:44670 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752193Ab3CHUfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:35:48 -0500
Message-ID: <513A4BC4.1040701@xenotime.net>
Date: Fri, 08 Mar 2013 12:36:20 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org, Andy King <acking@vmware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] misc/vmw_vmci: Add dependency on CONFIG_NET
References: <1361994101-15781-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1361994101-15781-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/13 11:41, Guenter Roeck wrote:
> Building the vmw_vmci driver with CONFIG_NET undefined results in:
> 
> drivers/built-in.o: In function `__qp_memcpy_from_queue.isra.13':
> vmci_queue_pair.c:(.text+0x1671a8): undefined reference to `memcpy_toiovec'
> drivers/built-in.o: In function `__qp_memcpy_to_queue.isra.14':
> vmci_queue_pair.c:(.text+0x167341): undefined reference to `memcpy_fromiovec'
> make[1]: [vmlinux] Error 1 (ignored)
> 
> since memcpy_toiovec and memcpy_fromiovec are defined in the networking code.
> Add the missing dependency.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/misc/vmw_vmci/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/vmw_vmci/Kconfig b/drivers/misc/vmw_vmci/Kconfig
> index 39c2eca..ea98f7e 100644
> --- a/drivers/misc/vmw_vmci/Kconfig
> +++ b/drivers/misc/vmw_vmci/Kconfig
> @@ -4,7 +4,7 @@
>  
>  config VMWARE_VMCI
>  	tristate "VMware VMCI Driver"
> -	depends on X86 && PCI
> +	depends on X86 && PCI && NET
>  	help
>  	  This is VMware's Virtual Machine Communication Interface.  It enables
>  	  high-speed communication between host and guest in a virtual
> 


-- 
~Randy
