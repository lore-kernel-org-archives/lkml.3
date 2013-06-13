Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab3FMPbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:31:21 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61034 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab3FMPbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:31:17 -0400
Message-ID: <1371137471.3252.110.camel@edumazet-glaptop>
Subject: Re: [PATCH v3 net-next 3/4] net: change sysctl_net_ll_poll into an
 unsigned int
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Avner Ben Hanoch <avnerb@mellanox.com>, Or Kehati <ork@mellanox.com>,
        sockperf-dev@googlegroups.com, Eliezer Tamir <eliezer@tamir.org.il>
Date: Thu, 13 Jun 2013 08:31:11 -0700
In-Reply-To: <20130613144645.4875.47741.stgit@ladj378.jer.intel.com>
References: <20130613144613.4875.46858.stgit@ladj378.jer.intel.com>
	 <20130613144645.4875.47741.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-13 at 17:46 +0300, Eliezer Tamir wrote:
> There is no reason for sysctl_net_ll_poll to be an unsigned long.
> Change it into an unsigned int.
> Fix the proc handler.
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---
> 
>  include/net/ll_poll.h      |    2 +-
>  net/core/sysctl_net_core.c |    4 ++--
>  net/socket.c               |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/ll_poll.h b/include/net/ll_poll.h
> index c75a611..9f7007f 100644
> --- a/include/net/ll_poll.h
> +++ b/include/net/ll_poll.h
> @@ -30,7 +30,7 @@
>  #ifdef CONFIG_NET_LL_RX_POLL
>  
>  struct napi_struct;
> -extern unsigned long sysctl_net_ll_poll __read_mostly;
> +extern unsigned int sysctl_net_ll_poll __read_mostly;
>  

Oh well, you re-introduce the overflow

hint : you defined 

#define USECS_TO_NS(us) (us << 10)


