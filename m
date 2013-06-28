Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab3F1EnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 00:43:10 -0400
Received: from one.firstfloor.org ([193.170.194.197]:43602 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3F1EnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 00:43:08 -0400
Date: Fri, 28 Jun 2013 06:43:05 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v4 net-next] net: poll/select low latency socket support
Message-ID: <20130628044305.GQ6123@two.firstfloor.org>
References: <20130624072751.26134.78163.stgit@ladj378.jer.intel.com>
 <20130624072803.26134.41593.stgit@ladj378.jer.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624072803.26134.41593.stgit@ladj378.jer.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -400,6 +402,8 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
>  	poll_table *wait;
>  	int retval, i, timed_out = 0;
>  	unsigned long slack = 0;
> +	unsigned int ll_flag = POLL_LL;
> +	u64 ll_time = ll_end_time();

So you're adding a sched_clock to every select call, even if it has
nothing to do with ll? 

That seems rather drastic. select can be performance critical.

-andi
