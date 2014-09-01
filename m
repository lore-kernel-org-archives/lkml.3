Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaIANvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:51:00 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:59716 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaIANu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:50:58 -0400
MIME-Version: 1.0
In-Reply-To: <1409571154-50408-1-git-send-email-shakilk1729@gmail.com>
References: <1409571154-50408-1-git-send-email-shakilk1729@gmail.com>
Date: Mon, 1 Sep 2014 09:50:57 -0400
Message-ID: <CAHQdGtQAwp_QuQE-xmjJNkcxbu7g4QtYQv8qrPT_qWpkym1GZg@mail.gmail.com>
Subject: Re: [PATCH] Next branch: authgss: authgss.c: Fix warnings for
 uninitizlized variable expire
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Shakil A Khan <shakilk1729@gmail.com>
Cc: Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        William Andros Adamson <andros@netapp.com>,
        Jeffrey Layton <jlayton@primarydata.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bruce Fields <bfields@fieldses.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 7:32 AM, Shakil A Khan <shakilk1729@gmail.com> wrote:
> Signed-off-by : Shakil A Khan <shakilk1729@gmail.com>
> ---
>  net/sunrpc/auth_gss/auth_gss.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> index afb292c..bea0951 100644
> --- a/net/sunrpc/auth_gss/auth_gss.c
> +++ b/net/sunrpc/auth_gss/auth_gss.c
> @@ -1387,7 +1387,7 @@ gss_key_timeout(struct rpc_cred *rc)
>         struct gss_cred *gss_cred = container_of(rc, struct gss_cred, gc_base);
>         struct gss_cl_ctx *ctx;
>         unsigned long now = jiffies;
> -       unsigned long expire;
> +       unsigned long expire = 0;
>
>         rcu_read_lock();
>         ctx = rcu_dereference(gss_cred->gc_ctx);
> --
> 1.7.1

That would be a compiler bug, not a kernel bug. The kernel code is
perfectly correct as it stands, and will never access the
uninitialised variable.

-- 
Trond Myklebust

Linux NFS client maintainer, PrimaryData

trond.myklebust@primarydata.com
