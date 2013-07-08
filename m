Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab3GHT3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:29:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20947 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3GHT3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:29:22 -0400
Date: Mon, 8 Jul 2013 15:28:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: jeremy@goop.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: remove unused Kconfig parameter
Message-ID: <20130708192854.GF4927@phenom.dumpdata.com>
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 08:28:24AM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the XEN_PRIVILEGED_GUEST kernel
> configuration parameter defined in arch/x86/xen/Kconfig, but used
> nowhere in the makefiles and source code.
> 
> This dummy parameter was added 3 years back, and it may
> make sense to remove it now, as the reasons to use it were not
> very clear.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Can't remove it. It is used by grub2.

> ---
>  arch/x86/xen/Kconfig | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> index 1a3c765..b6401dc 100644
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -19,11 +19,6 @@ config XEN_DOM0
>  	depends on XEN && PCI_XEN && SWIOTLB_XEN
>  	depends on X86_LOCAL_APIC && X86_IO_APIC && ACPI && PCI
>  
> -# Dummy symbol since people have come to rely on the PRIVILEGED_GUEST
> -# name in tools.
> -config XEN_PRIVILEGED_GUEST
> -	def_bool XEN_DOM0
> -
>  config XEN_PVHVM
>  	def_bool y
>  	depends on XEN && PCI && X86_LOCAL_APIC
> -- 
> 1.8.1.2
> 
