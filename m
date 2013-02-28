Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3B1WxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:53:24 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:36424 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3B1WxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:53:23 -0500
X-IronPort-AV: E=Sophos;i="4.84,757,1355097600"; 
   d="scan'208";a="9922485"
Date: Thu, 28 Feb 2013 22:53:21 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Kees Cook <keescook@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v2] arch/x86/xen: remove depends on CONFIG_EXPERIMENTAL
In-Reply-To: <20130228215640.GA3136@www.outflux.net>
Message-ID: <alpine.DEB.2.02.1302282251200.5210@kaball.uk.xensource.com>
References: <20130228215640.GA3136@www.outflux.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2013, Kees Cook wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Cc: Mukesh Rathor <mukesh.rathor@oracle.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
> 
> v2:
>  - drop EXPERIMENTAL from bool and help text too.
> 
> ---
>  arch/x86/xen/Kconfig |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> index 93ff4e1..6c5802f 100644
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -52,12 +52,10 @@ config XEN_DEBUG_FS
>  	  Enabling this option may incur a significant performance overhead.
>  
>  config XEN_X86_PVH
> -	bool "Support for running as a PVH guest (EXPERIMENTAL)"
> -	depends on X86_64 && XEN && EXPERIMENTAL
> +	bool "Support for running as a PVH guest"
> +	depends on X86_64 && XEN
>  	default n
>  	help
>  	   This option enables support for running as a PVH guest (PV guest
>  	   using hardware extensions) under a suitably capable hypervisor.
> -	   This option is EXPERIMENTAL because the hypervisor interfaces
> -	   which it uses is not yet considered stable therefore backwards and
> -	   forwards compatibility is not yet guaranteed.  If unsure, say N.
> +	   If unsure, say N.

Please do not change the text this way.
The fact that CONFIG_EXPERIMENTAL is going away it doesn't change the
fact that this feature is experimental.
Maybe you want to replace EXPERIMENTAL with experimental, or if
experimental has become as taboo word, I am sure you can find a suitable
synonym.
