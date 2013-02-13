Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab3BMJzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:55:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636Ab3BMJzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:55:50 -0500
Subject: Re: [patch for-3.8] net, sctp: remove CONFIG_EXPERIMENTAL
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vlad Yasevich <vyasevich@gmail.com>
In-Reply-To: <alpine.DEB.2.02.1302121619340.3805@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1302111344140.14071@chino.kir.corp.google.com>
	 <1360662605.2719.13.camel@menhir>
	 <CA+55aFzCRLy5AN24rJUvbLf5HNeumn=qtS0dA9f9+2CKOLgu7A@mail.gmail.com>
	 <alpine.DEB.2.02.1302121207250.25566@chino.kir.corp.google.com>
	 <alpine.DEB.2.02.1302121619340.3805@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 13 Feb 2013 09:53:34 +0000
Message-ID: <1360749214.2762.9.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2013-02-12 at 16:24 -0800, David Rientjes wrote:
> From: Kees Cook <keescook@chromium.org>
> 
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  Ah, look what I found in my mailbox from October 23.  The patch for dlm
>  was merged, but this wasn't for some reason.  It's acked by the 
>  maintainer so it should be good to go and fixes the reported build error:
> 
>         net/built-in.o: In function `sctp_crc32c':
>         include/net/sctp/checksum.h:51: undefined reference to `crc32c'
>         include/net/sctp/checksum.h:51: undefined reference to `crc32c'
>         include/net/sctp/checksum.h:51: undefined reference to `crc32c'
>         include/net/sctp/checksum.h:51: undefined reference to `crc32c'
>         include/net/sctp/checksum.h:51: undefined reference to `crc32c'
>         net/built-in.o:include/net/sctp/checksum.h:51: more undefined references to `crc32c' follow
> 
>  And I guess "dlm not being marked experimental for a long time" meant
>  three months.
> 
Yes, I was surprised about that. We removed that tag from GFS2 back in
2010 it seems and I'm surprised that it didn't get removed from DLM at
around the same time. Either way though, it is a long time since either
have been experimental in reality, as both are stable and have many
users.

Also SCTP is only a (run time) option for DLM, and few users will
actually use it, since most people will use the TCP transport instead.

Anyway, this patch looks ok to me, so:
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.


>  net/sctp/Kconfig | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
> --- a/net/sctp/Kconfig
> +++ b/net/sctp/Kconfig
> @@ -3,8 +3,8 @@
>  #
>  
>  menuconfig IP_SCTP
> -	tristate "The SCTP Protocol (EXPERIMENTAL)"
> -	depends on INET && EXPERIMENTAL
> +	tristate "The SCTP Protocol"
> +	depends on INET
>  	depends on IPV6 || IPV6=n
>  	select CRYPTO
>  	select CRYPTO_HMAC


