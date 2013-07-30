Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab3G3Pll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 11:41:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40898 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3G3Plj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 11:41:39 -0400
Date: Tue, 30 Jul 2013 11:40:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, Ian Campbell <Ian.Campbell@citrix.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] do not allow XEN_TMEM on ARM64
Message-ID: <20130730154035.GA9245@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1307231745520.4893@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307231745520.4893@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 05:46:58PM +0100, Stefano Stabellini wrote:
> tmem is not supported on arm or arm64 yet.

So .. I lost track of the conversation about this. We chatted
about this on the hyepervisor side and then there is also
this patch.


What did we decide?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index 9e02d60..a18f350 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -145,7 +146,7 @@ config SWIOTLB_XEN
>  
>  config XEN_TMEM
>  	tristate
> -	depends on !ARM
> +	depends on !ARM && !ARM64
>  	default m if (CLEANCACHE || FRONTSWAP)
>  	help
>  	  Shim to interface in-kernel Transcendent Memory hooks
