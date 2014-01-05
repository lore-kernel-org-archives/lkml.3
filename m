Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbaAEWWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 17:22:24 -0500
Received: from smtp.citrix.com ([66.165.176.89]:54322 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbaAEWWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 17:22:23 -0500
X-IronPort-AV: E=Sophos;i="4.95,609,1384300800"; 
   d="scan'208";a="89921251"
Date: Sun, 5 Jan 2014 22:22:21 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Josh Boyer <jwboyer@redhat.com>
CC: Paul Durrant <Paul.Durrant@citrix.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-netback: Include header for vmalloc
Message-ID: <20140105222221.GA16984@zion.uk.xensource.com>
References: <20140105152401.GF18517@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140105152401.GF18517@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 10:24:01AM -0500, Josh Boyer wrote:
> Commit ac3d5ac27735 ("xen-netback: fix guest-receive-side array sizes")
> added calls to vmalloc and vfree in the interface.c file without including
> <linux/vmalloc.h>.  This causes build failures if the
> -Werror=implicit-function-declaration flag is passed.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>

Acked-by: Wei Liu <wei.liu2@citrix.com>

Thanks
Wei.

> ---
>  drivers/net/xen-netback/interface.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
> index 34ca4e5..fff8cdd 100644
> --- a/drivers/net/xen-netback/interface.c
> +++ b/drivers/net/xen-netback/interface.c
> @@ -34,6 +34,7 @@
>  #include <linux/ethtool.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/if_vlan.h>
> +#include <linux/vmalloc.h>
>  
>  #include <xen/events.h>
>  #include <asm/xen/hypercall.h>
> -- 
> 1.8.4.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
