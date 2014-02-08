Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbaBHUMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:12:53 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46446 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbaBHUMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:12:51 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 8 Feb 2014 12:12:45 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 10/13] net: Move prototype declaration to header file
 include/net/datalink.h from net/ipx/af_ipx.c
Message-ID: <20140208201245.GJ20885@leaf>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
 <f1d749c96d96ee3d237723dbcefcdbf43387eacf.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f1d749c96d96ee3d237723dbcefcdbf43387eacf.1391888654.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 01:35:38AM +0530, Rashika Kheria wrote:
> Move prototype declarations of function to header file
> include/net/datalink.h from net/ipx/af_ipx.c because they are used by
> more than one file.
> 
> This eliminates the following warning in net/ipx/pe2.c:
> net/ipx/pe2.c:20:24: warning: no previous prototype for ‘make_EII_client’ [-Wmissing-prototypes]
> net/ipx/pe2.c:32:6: warning: no previous prototype for ‘destroy_EII_client’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  include/net/datalink.h |    2 ++
>  net/ipx/af_ipx.c       |    4 +---
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/datalink.h b/include/net/datalink.h
> index deb7ca7..93cb18f 100644
> --- a/include/net/datalink.h
> +++ b/include/net/datalink.h
> @@ -15,4 +15,6 @@ struct datalink_proto {
>  	struct list_head node;
>  };
>  
> +struct datalink_proto *make_EII_client(void);
> +void destroy_EII_client(struct datalink_proto *dl);
>  #endif
> diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
> index e5a00a9..224d058 100644
> --- a/net/ipx/af_ipx.c
> +++ b/net/ipx/af_ipx.c
> @@ -52,6 +52,7 @@
>  #include <net/p8022.h>
>  #include <net/psnap.h>
>  #include <net/sock.h>
> +#include <net/datalink.h>
>  #include <net/tcp_states.h>
>  
>  #include <asm/uaccess.h>
> @@ -1977,9 +1978,6 @@ static struct notifier_block ipx_dev_notifier = {
>  	.notifier_call	= ipxitf_device_event,
>  };
>  
> -extern struct datalink_proto *make_EII_client(void);
> -extern void destroy_EII_client(struct datalink_proto *);
> -
>  static const unsigned char ipx_8022_type = 0xE0;
>  static const unsigned char ipx_snap_id[5] = { 0x0, 0x0, 0x0, 0x81, 0x37 };
>  static const char ipx_EII_err_msg[] __initconst =
> -- 
> 1.7.9.5
> 
