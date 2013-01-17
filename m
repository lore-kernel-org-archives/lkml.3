Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025Ab3AQDPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:15:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42943 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432Ab3AQDPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 22:15:40 -0500
Date: Wed, 16 Jan 2013 22:15:38 -0500 (EST)
Message-Id: <20130116.221538.1756411165313441486.davem@davemloft.net>
To: carlos@systemhalted.org
Cc: vapier@gentoo.org, libc-alpha@sourceware.org, bhutchings@solarflare.com,
        yoshfuji@linux-ipv6.org, amwang@redhat.com, tmb@mageia.org,
        eblake@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, libvirt-list@redhat.com, tgraf@suug.ch,
        schwab@suse.de
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and
 <linux/in6.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <50F75EA7.4060309@systemhalted.org>
References: <201301161205.04502.vapier@gentoo.org>
	<20130116.135744.697469565804508454.davem@davemloft.net>
	<50F75EA7.4060309@systemhalted.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos O'Donell <carlos@systemhalted.org>
Date: Wed, 16 Jan 2013 21:15:03 -0500

> +/* If a glibc-based userspace has already included in.h, then we will not 
> + * define in6_addr (nor the defines), sockaddr_in6, or ipv6_mreq. The
> + * ABI used by the kernel and by glibc match exactly. Neither the kernel
> + * nor glibc should break this ABI without coordination.
> + */
> +#ifndef _NETINET_IN_H
> +

I think we should shoot for a non-glibc-centric solution.

I can't imagine that other libc's won't have the same exact problem
with their netinet/in.h conflicting with the kernel's, redefining
structures like in6_addr, that we'd want to provide a protection
scheme for here as well.

Let's pick some more generic names and themes for the CPP macros and
comments we use to protect the header file blocks and describe that
protection scheme.

Thanks.
