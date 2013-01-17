Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab3AQDvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 22:51:44 -0500
Received: from mail-da0-f50.google.com ([209.85.210.50]:45117 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309Ab3AQDvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 22:51:42 -0500
MIME-Version: 1.0
In-Reply-To: <1358390177-24422-1-git-send-email-nickolai@csail.mit.edu>
References: <1358390177-24422-1-git-send-email-nickolai@csail.mit.edu>
Date: Wed, 16 Jan 2013 21:51:42 -0600
Message-ID: <CAH2r5mv=hMN7yHLf0wLMnyjpeQRj-1SmN8n2581AMFZput5nqg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix srcip_matches() for ipv6
From: Steve French <smfrench@gmail.com>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes sense.

How did you discover this - did you have an ipv6 test case or by
inspection or ...?

On Wed, Jan 16, 2013 at 8:36 PM, Nickolai Zeldovich
<nickolai@csail.mit.edu> wrote:
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
>         }
>         case AF_INET6: {
>                 struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
> -               struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)&rhs;
> +               struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
>                 return ipv6_addr_equal(&saddr6->sin6_addr, &vaddr6->sin6_addr);
>         }
>         default:
> --
> 1.7.10.4
>



-- 
Thanks,

Steve
