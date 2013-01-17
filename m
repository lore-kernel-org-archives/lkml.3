Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab3AQQYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:24:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064Ab3AQQY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:24:29 -0500
Date: Thu, 17 Jan 2013 11:24:12 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: fix srcip_matches() for ipv6
Message-ID: <20130117112412.095f7aef@corrin.poochiereds.net>
In-Reply-To: <1358390177-24422-1-git-send-email-nickolai@csail.mit.edu>
References: <1358390177-24422-1-git-send-email-nickolai@csail.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 21:36:17 -0500
Nickolai Zeldovich <nickolai@csail.mit.edu> wrote:

> srcip_matches() previously had code like this:
> 
>   srcip_matches(..., struct sockaddr *rhs) {
>     /* ... */
>     struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *) &rhs;
>     return ipv6_addr_equal(..., &vaddr6->sin6_addr);
>   }
> 
> which interpreted the values on the stack after the 'rhs' pointer as an
> ipv6 address.  The correct thing to do is to use 'rhs', not '&rhs'.
> 
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> ---
>  fs/cifs/connect.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 17c3643..12b3da3 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1917,7 +1917,7 @@ srcip_matches(struct sockaddr *srcaddr, struct sockaddr *rhs)
>  	}
>  	case AF_INET6: {
>  		struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
> -		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)&rhs;
> +		struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
>  		return ipv6_addr_equal(&saddr6->sin6_addr, &vaddr6->sin6_addr);
>  	}
>  	default:

Nice catch...

Reviewed-by: Jeff Layton <jlayton@redhat.com>
