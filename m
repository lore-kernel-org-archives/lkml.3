Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506Ab3AQDmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:42:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757927Ab3AQDmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 22:42:13 -0500
Message-ID: <1358394046.3855.10.camel@cr0>
Subject: Re: Redefinition of struct in6_addr in <netinet/in.h> and
 <linux/in6.h>
From: Cong Wang <amwang@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: David Miller <davem@davemloft.net>, bhutchings@solarflare.com,
        libc-alpha@sourceware.org, yoshfuji@linux-ipv6.org, tmb@mageia.org,
        eblake@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, libvirt-list@redhat.com, tgraf@suug.ch,
        schwab@suse.de, carlos@systemhalted.org
Date: Thu, 17 Jan 2013 11:40:46 +0800
In-Reply-To: <201301161422.19202.vapier@gentoo.org>
References: <201301161205.04502.vapier@gentoo.org>
	 <201301161228.42592.vapier@gentoo.org>
	 <20130116.135959.90676245194307972.davem@davemloft.net>
	 <201301161422.19202.vapier@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 14:22 -0500, Mike Frysinger wrote:
> 
> but this is still too vague.  what headers/definitions do people want to see 
> simultaneously included ?  changes would be needed on both sides (kernel & C 
> library).
> 

Hi, Mike,

Please take a look at my first email in this thread. The user
application includes <linux/if_bridge.h> and <netinet/in.h>.

<linux/if_bridge.h> uses struct_in6 but doesn't include <linux/in6.h>
(this is my bad, sorry), an obvious fix is just including <linux/in6.h>.
But this immediately breaks applications which include
<linux/if_bridge.h> and <netinet/in.h>, just as what Thomas reported.

And if_bridge.h is kernel-specific, there is no corresponding glibc one,
so you can't blame applications which include both of them.

Thanks.

