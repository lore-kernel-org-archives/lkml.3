Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab3EBPi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:38:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10881 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756652Ab3EBPi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:38:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,597,1363132800"; 
   d="scan'208";a="22934559"
Date: Thu, 2 May 2013 16:38:50 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH, RFC 18/22] Xen: SWIOTLB is only used on x86
In-Reply-To: <1367507786-505303-19-git-send-email-arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1305021638100.5398@kaball.uk.xensource.com>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-19-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Arnd Bergmann wrote:
> Enabling SWIOTLB_XEN on ARM results in build errors because the
> underlying SWIOTLB is only available on X86:
> 
> drivers/xen/swiotlb-xen.c: In function 'is_xen_swiotlb_buffer':
> drivers/xen/swiotlb-xen.c:105:2: error: implicit declaration of function 'mfn_to_local_pfn
> 
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  drivers/xen/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index dd4d9cb..f03bf50 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -141,7 +141,7 @@ config XEN_GRANT_DEV_ALLOC
>  
>  config SWIOTLB_XEN
>  	def_bool y
> -	depends on PCI
> +	depends on PCI && X86
>  	select SWIOTLB
>  
>  config XEN_TMEM
> -- 
> 1.8.1.2
> 
