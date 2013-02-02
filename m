Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab3BBM5X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 07:57:23 -0500
Received: from fieldses.org ([174.143.236.118]:50118 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab3BBM5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 07:57:21 -0500
Date: Sat, 2 Feb 2013 07:57:19 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: linux-next: build failure after merge of the nfsd tree
Message-ID: <20130202125719.GF30668@fieldses.org>
References: <20130202130403.a29346b583a802ed6ce6880b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202130403.a29346b583a802ed6ce6880b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 01:04:03PM +1100, Stephen Rothwell wrote:
> Hi,
> 
> After merging the nfsd tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> fs/nfs/dns_resolve.c: In function 'nfs_dns_resolver_cache_init':
> fs/nfs/dns_resolve.c:375:4: error: 'struct cache_detail' has no member named 'cache_upcall'
> fs/nfs/dns_resolve.c:375:35: warning: left-hand operand of comma expression has no effect [-Wunused-value]
> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> fs/nfs/dns_resolve.c:375:35: warning: value computed is not used [-Wunused-value]
> 
> Caused by commit aab982cb5dfb ("SUNRPC: remove cache_detail->cache_upcall
> callback").

Yes, I knew why we'd introduced cache_upcall, so I'm not sure how I
overlooked that.  It must have slipped through testing because I didn't
set CONFIG_NFS_USE_KERNEL_DNS.

We may just be able to revert that patch....  I can take care of that by
tomorrow.

> Also, why don't those statements end in semicolons?

Looks like that whole chunk was cut-and-pasted from a previous static
initializer in 1b340d0118da1d7c60c664f17d7c8fce2bb1cd9d "NFS: DNS
resolver cache per network namespace context introduced".

> 
> I have used the nsfd tree from next-20130128 for today.

Thanks.

--b.
