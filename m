Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3AREz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 23:55:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58158 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3AREz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 23:55:27 -0500
Date: Thu, 17 Jan 2013 23:55:24 -0500 (EST)
Message-Id: <20130117.235524.2010232687612037902.davem@davemloft.net>
To: vapier@gentoo.org
Cc: libc-alpha@sourceware.org, bhutchings@solarflare.com,
        yoshfuji@linux-ipv6.org, amwang@redhat.com, tmb@mageia.org,
        eblake@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, libvirt-list@redhat.com, tgraf@suug.ch,
        schwab@suse.de, carlos@systemhalted.org
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and
 <linux/in6.h>
From: David Miller <davem@davemloft.net>
In-Reply-To: <201301172314.34193.vapier@gentoo.org>
References: <1358351232.2923.10.camel@bwh-desktop.uk.solarflarecom.com>
	<20130116.164511.2027039182184636075.davem@davemloft.net>
	<201301172314.34193.vapier@gentoo.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 17 Jan 2013 23:14:31 -0500

> the kernel already exports many types with a __kernel_ prefix.  i changed the 
> kernel headers in Gentoo for a few releases (2.6.28 - 2.6.34) to do the same 
> thing to pretty much all the networking headers.  a few packages broke, but 
> the number was low, and trivial to fix (a sed would do it most of the time).
> 
> it's also trivial for userland packages to detect that they need to do this 
> sort of thing in a local header by using linux/version.h and a set of defines 
> to redirect the new structure name back to the old one.
> 
> would be a lot cleaner to just break it and be done.

We are not at liberty to break something that has legitimately
compiled successfully for two decades.

Your __kernel_ prefix idea breaks compilation just as equally.

One thing you certainly don't have to be is happy about this header
file situation, but you cannot use that dissatisfaction as
justification to make the situation worse by breaking the build for
people outside of the world you directly control.
