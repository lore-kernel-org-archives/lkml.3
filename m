Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934864Ab3DISKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:10:25 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59683 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761262Ab3DISKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:10:24 -0400
Message-ID: <1365531021.3887.151.camel@edumazet-glaptop>
Subject: Re: [PATCH] net: pre-clear the returned sockaddr_storage variable
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Brad Spengler <spender@grsecurity.net>
Date: Tue, 09 Apr 2013 11:10:21 -0700
In-Reply-To: <20130409175024.GA19308@www.outflux.net>
References: <20130409175024.GA19308@www.outflux.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-09 at 10:50 -0700, Kees Cook wrote:
> To avoid future stack content leaks in the various protocols, pre-clear
> the returned memory.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Suggested-by: Brad Spengler <spender@grsecurity.net>
> ---
>  net/socket.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 88f759a..4d2af0d 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -1838,7 +1838,7 @@ SYSCALL_DEFINE6(recvfrom, int, fd, void __user *, ubuf, size_t, size,
>  	struct socket *sock;
>  	struct iovec iov;
>  	struct msghdr msg;
> -	struct sockaddr_storage address;
> +	struct sockaddr_storage address = { };
>  	int err, err2;
>  	int fput_needed;
>  
> @@ -2185,7 +2185,7 @@ static int __sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
>  	int err, total_len, len;
>  
>  	/* kernel mode address */
> -	struct sockaddr_storage addr;
> +	struct sockaddr_storage addr = { };
>  
>  	/* user mode address pointers */
>  	struct sockaddr __user *uaddr;
> -- 
> 1.7.9.5
> 
> 

Nack, for obvious performance reasons.



