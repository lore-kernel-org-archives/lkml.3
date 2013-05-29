Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966176Ab3E2Nhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:37:32 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:50496 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966078Ab3E2Nh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:37:29 -0400
Message-ID: <1369834647.5109.15.camel@edumazet-glaptop>
Subject: Re: [PATCH v6 net-next 2/5] net: implement support for low latency
 socket polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 29 May 2013 06:37:27 -0700
In-Reply-To: <20130529063935.27486.18610.stgit@ladj378.jer.intel.com>
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>
	 <20130529063935.27486.18610.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 09:39 +0300, Eliezer Tamir wrote:

> +/* we don't mind a ~2.5% imprecision */
> +#define TSC_MHZ (tsc_khz >> 10)
> +
> +static inline unsigned long ll_end_time(void)
> +{
> +	return TSC_MHZ * ACCESS_ONCE(sysctl_net_ll_poll) + get_cycles();
> +}static inline unsigned long ll_end_time(void)
>+{
>+	return TSC_MHZ * ACCESS_ONCE(sysctl_net_ll_poll) + get_cycles();
>+}

This can overflow.

Multiply is giving 32bits, as tsc_khz is an int, and sysctl_net_ll_poll
is an int.

unsigned long sysctl_net_ll_poll ?

Also, if we want this to work on i386, the correct type to use for
ll_end_time(void) would be cycles_t



