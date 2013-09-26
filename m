Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061Ab3IZMjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756938Ab3IZMjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:39:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1380175008-13090-1-git-send-email-olof@lixom.net>
References: <1380175008-13090-1-git-send-email-olof@lixom.net> <20130920150927.16220.33305.stgit@warthog.procyon.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: dhowells@redhat.com, Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFS: Don't use debug-printk-only local variables
Date: Thu, 26 Sep 2013 13:39:03 +0100
Message-ID: <3222.1380199143@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson <olof@lixom.net> wrote:

> -		struct nfs_inode *nfsi = NFS_I(page->mapping->host);
>  		struct fscache_cookie *cookie = nfs_i_fscache(page->mapping->host);
>  
>  		BUG_ON(!cookie);
>  		dfprintk(FSCACHE, "NFS: fscache releasepage (0x%p/0x%p/0x%p)\n",
> -			 cookie, page, nfsi);
> +			 cookie, page, NFS_I(page->mapping->host));

This is really the wrong fix.  The null dfprintk() should use no_printk().

David
