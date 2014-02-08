Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaBHUOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:14:38 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:44216 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaBHUOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:14:37 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 8 Feb 2014 12:14:29 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 11/13] net: Move prototype declaration to header file
 include/net/net_namespace.h from net/ipx/af_ipx.c
Message-ID: <20140208201429.GK20885@leaf>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
 <0d855fd121af07a77d258aec045b71dfa68cb0af.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0d855fd121af07a77d258aec045b71dfa68cb0af.1391888654.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 01:37:20AM +0530, Rashika Kheria wrote:
> Move prototype declaration of function to header file
> include/net/net_namespace.h from net/ipx/af_ipx.c because they are used
> by more than one file.
> 
> This eliminates the following warning in net/ipx/sysctl_net_ipx.c:
> net/ipx/sysctl_net_ipx.c:33:6: warning: no previous prototype for ‘ipx_register_sysctl’ [-Wmissing-prototypes]
> net/ipx/sysctl_net_ipx.c:38:6: warning: no previous prototype for ‘ipx_unregister_sysctl’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

You should move the entire ifdef/else block into the header file, so
that the stubs are available as well.

>  include/net/net_namespace.h |    3 +++
>  net/ipx/af_ipx.c            |    6 ++----
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index da68c9a..a43435c 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -162,6 +162,9 @@ extern struct list_head net_namespace_list;
>  struct net *get_net_ns_by_pid(pid_t pid);
>  struct net *get_net_ns_by_fd(int pid);
>  
> +void ipx_register_sysctl(void);
> +void ipx_unregister_sysctl(void);
> +
>  #ifdef CONFIG_NET_NS
>  void __put_net(struct net *net);
>  
> diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
> index 224d058..aa2abb8 100644
> --- a/net/ipx/af_ipx.c
> +++ b/net/ipx/af_ipx.c
> @@ -54,13 +54,11 @@
>  #include <net/sock.h>
>  #include <net/datalink.h>
>  #include <net/tcp_states.h>
> +#include <net/net_namespace.h>
>  
>  #include <asm/uaccess.h>
>  
> -#ifdef CONFIG_SYSCTL
> -extern void ipx_register_sysctl(void);
> -extern void ipx_unregister_sysctl(void);
> -#else
> +#ifndef CONFIG_SYSCTL
>  #define ipx_register_sysctl()
>  #define ipx_unregister_sysctl()
>  #endif
> -- 
> 1.7.9.5
> 
