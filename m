Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab3APPrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:47:18 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:64642 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab3APPrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:47:16 -0500
Message-ID: <1358351232.2923.10.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and
 <linux/in6.h>
From: Ben Hutchings <bhutchings@solarflare.com>
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
CC: Cong Wang <amwang@redhat.com>, Thomas Backlund <tmb@mageia.org>,
        Eric Blake <eblake@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <libvirt-list@redhat.com>,
        <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
        <libc-alpha@sourceware.org>, <schwab@suse.de>,
        <carlos@systemhalted.org>
Date: Wed, 16 Jan 2013 15:47:12 +0000
In-Reply-To: <50F6B761.8070106@linux-ipv6.org>
References: <50F2FF1B.3020708@mageia.org> <50F313A5.3020707@mageia.org>
	   <50F49B7E.50906@redhat.com> <50F52956.50201@mageia.org>
	  <1358244688.4264.7.camel@cr0> <50F53596.4070200@mageia.org>
	 <1358316366.14898.8.camel@cr0> <50F6B761.8070106@linux-ipv6.org>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19558.004
X-TM-AS-Result: No--27.489800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 23:21 +0900, YOSHIFUJI Hideaki wrote:
> Cong Wang wrote:
> > (Cc'ing some glibc developers...)
> > 
> > Hello,
> > 
> > In glibc source file inet/netinet/in.h and kernel source file
> > include/uapi/linux/in6.h, both define struct in6_addr, and both are
> > visible to user applications. Thomas reported a conflict below.
> > 
> > So, how can we handle this? /me is wondering why we didn't see this
> > before.
[...]
> This is not a new issue.  In addition to this,
> netinet/in.h also conflits with linux/in.h.
> 
> We might have
>  #if !defined(__GLIBC__) || !defined(_NETINET_IN_H)
>  :
>  #endif
> around those conflicting definitions in uapi/linux/in{,6}.h.

This only solves half the problem, as <netinet/in.h> might be included
after <linux/in.h>.  Also, not all Linux userland uses glibc.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

