Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3ETQWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:22:39 -0400
Received: from one.firstfloor.org ([193.170.194.197]:41052 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab3ETQWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:22:30 -0400
Date: Mon, 20 May 2013 18:22:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donanld.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v2 net-next 1/4] net: implement support for low latency
 socket polling
Message-ID: <20130520162227.GD24555@two.firstfloor.org>
References: <20130519102525.12527.83301.stgit@ladj378.jer.intel.com>
 <20130519102533.12527.12991.stgit@ladj378.jer.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130519102533.12527.12991.stgit@ladj378.jer.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index f98ca63..cfcf0ea 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -19,6 +19,11 @@ ip_no_pmtu_disc - BOOLEAN
>  	Disable Path MTU Discovery.
>  	default FALSE
>  
> +ip_low_latency_poll - INTEGER
> +	Low latency busy poll timeout. (needs CONFIG_INET_LL_RX_POLL)
> +	Approximate time in ms to spin waiting for packets on the device queue.
> +	default 0

Can you document the suggested value here?

Also I would add something like "may increase power usage"

The other thing I would add is a linuxmib statistic counter so that
we can see the polling happens.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
