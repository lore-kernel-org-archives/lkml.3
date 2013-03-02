Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3CBDm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:42:59 -0500
Received: from fieldses.org ([174.143.236.118]:37343 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab3CBDm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:42:57 -0500
Date: Fri, 1 Mar 2013 22:42:53 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the nfsd tree
Message-ID: <20130302034253.GC14264@fieldses.org>
References: <20130301120401.bcb4a3c571cb0d2b7af96a4b@canb.auug.org.au>
 <4FA345DA4F4AE44899BD2B03EEEC2FA9286A81EB@sacexcmbx05-prd.hq.netapp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA345DA4F4AE44899BD2B03EEEC2FA9286A81EB@sacexcmbx05-prd.hq.netapp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 01:19:42AM +0000, Myklebust, Trond wrote:
> On Fri, 2013-03-01 at 12:04 +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the nfsd tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > net/sunrpc/xprtsock.c:1923:30: error: 'struct rpc_task' has no member named 'tk_xprt'
> > 
> > Caused by commit dc107402ae06 ("SUNRPC: make AF_LOCAL connect
> > synchronous") interacting with commit 77102893ae68 ("SUNRPC: Nuke the
> > tk_xprt macro") from Linus' tree.
> > 
> > I have no idea how to fix this, so I have used the version of the nfsd
> > tree from next-20130228 for today.
> 
> Hi Bruce,
> 
> The attached patch should suffice to fix this up.

Thanks!

Looks like Linus got this right in the upstream merge.

--b.

> 
> Cheers
>   Trond
> 
> -- 
> Trond Myklebust
> Linux NFS client maintainer
> 
> NetApp
> Trond.Myklebust@netapp.com
> www.netapp.com

> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
> index 2e7e09c..c1d8476 100644
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -1918,9 +1918,8 @@ out:
>  	return status;
>  }
>  
> -static void xs_local_connect(struct rpc_task *task)
> +static void xs_local_connect(struct rpc_xprt *xprt, struct rpc_task *task)
>  {
> -	struct rpc_xprt *xprt = task->tk_xprt;
>  	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
>  	int ret;
>  

