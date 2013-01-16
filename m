Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab3APS5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:57:54 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37006 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab3APS5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:57:50 -0500
Date: Wed, 16 Jan 2013 13:57:44 -0500 (EST)
Message-Id: <20130116.135744.697469565804508454.davem@davemloft.net>
To: vapier@gentoo.org
Cc: libc-alpha@sourceware.org, bhutchings@solarflare.com,
        yoshfuji@linux-ipv6.org, amwang@redhat.com, tmb@mageia.org,
        eblake@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, libvirt-list@redhat.com, tgraf@suug.ch,
        schwab@suse.de, carlos@systemhalted.org
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and
 <linux/in6.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <201301161205.04502.vapier@gentoo.org>
References: <50F6B761.8070106@linux-ipv6.org>
	<1358351232.2923.10.camel@bwh-desktop.uk.solarflarecom.com>
	<201301161205.04502.vapier@gentoo.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 16 Jan 2013 12:04:56 -0500

> certainly true, but the current expectation is that you don't mix your ABIs.  
> if you're programming with the C library API, then use the C library headers.  
> if you're banging directly on the kernel, then use the kernel headers.  not 
> saying it's a perfect solution, but it works for the vast majority of use 
> cases.

This isn't how real life works.

GLIBC itself brings in some of the kernel headers, as do various library
headers for libraries other than glibc.

So you can get these conflicting headers included indirectly, and it is
of no fault of any of the various parties involved.

We have to make them work when included at the same time somehow, and
this is totally unavoidable.
