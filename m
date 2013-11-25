Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab3KYQyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:54:25 -0500
Received: from smtp.citrix.com ([66.165.176.89]:25385 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742Ab3KYQyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 11:54:21 -0500
X-IronPort-AV: E=Sophos;i="4.93,768,1378857600"; 
   d="scan'208";a="77905430"
Message-ID: <1385398458.22002.99.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH 1/1] xen-netback: include definition of csum_ipv6_magic
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Andy Whitcroft <apw@canonical.com>
CC: Wei Liu <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Mon, 25 Nov 2013 16:54:18 +0000
In-Reply-To: <1385398354-21636-1-git-send-email-apw@canonical.com>
References: <1385398354-21636-1-git-send-email-apw@canonical.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-25 at 16:52 +0000, Andy Whitcroft wrote:
> We are now using csum_ipv6_magic, include the appropriate header.
> Avoids the following error:
> 
>     drivers/net/xen-netback/netback.c:1313:4: error: implicit declaration of function 'csum_ipv6_magic' [-Werror=implicit-function-declaration]
>         tcph->check = ~csum_ipv6_magic(&ipv6h->saddr,
> 
> Signed-off-by: Andy Whitcroft <apw@canonical.com>

Acked-by: Ian Campbell <ian.campbell@citrix.com>

Thanks!

> ---
>  drivers/net/xen-netback/netback.c | 1 +
>  1 file changed, 1 insertion(+)
> 
>     Found while trying to couple latest kernels for arm64 platforms.
>     Looks like it got missed in the transition.
> 
>     -apw
> 
> diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
> index 919b650..64f0e0d 100644
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -39,6 +39,7 @@
>  #include <linux/udp.h>
>  
>  #include <net/tcp.h>
> +#include <net/ip6_checksum.h>
>  
>  #include <xen/xen.h>
>  #include <xen/events.h>


