Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936677Ab3DJRbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:31:13 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:49147 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936514Ab3DJRbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:31:09 -0400
Date: Wed, 10 Apr 2013 13:31:03 -0400 (EDT)
From: Eric Paris <eparis@redhat.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Message-ID: <1216477171.11118824.1365615063121.JavaMail.root@redhat.com>
In-Reply-To: <5161347B.8090604@asianux.com>
References: <5161347B.8090604@asianux.com>
Subject: Re: [PATCH] kernel: audit: beautify code, for extern function,
 better to check its parameters by itself
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.12]
X-Mailer: Zimbra 8.0.3_GA_5664 (ZimbraWebClient - FF20 (Linux)/8.0.3_GA_5664)
Thread-Topic: kernel: audit: beautify code, for extern function, better to check its parameters by itself
Thread-Index: jg9aahtYnAMiaslW9ht41kjXI4YW3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> 
>   __audit_socketcall is an extern function.
>   better to check its parameters by itself.
> 
>     also can return error code, when fail (find invalid parameters).
>     also use macro instead of real hard code number
>     also give related comments for it.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/linux/audit.h |   12 ++++++++----
>  kernel/auditsc.c      |    9 ++++++---
>  net/socket.c          |    6 ++++--
>  3 files changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h

> @@ -354,7 +358,7 @@ static inline int audit_bprm(struct linux_binprm *bprm)
>  {
>  	return 0;
>  }
> -static inline void audit_socketcall(int nargs, unsigned long *args)
> +static inline int audit_socketcall(int nargs, unsigned long *args)
>  { }
>  static inline void audit_fd_pair(int fd1, int fd2)
>  { }

This now returns a value but you forgot to return a value.  Thus this would not even build...   I fixed it up myself.

-Eric
