Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab3IRCAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 22:00:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60896 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3IRCAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 22:00:38 -0400
Date: Wed, 18 Sep 2013 03:00:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>
Subject: Re: linux-next: manual merge of the vfs tree with the aio-direct tree
Message-ID: <20130918020035.GK13318@ZenIV.linux.org.uk>
References: <20130918105638.6fa7c29605c14b408b7f5a7e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918105638.6fa7c29605c14b408b7f5a7e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 10:56:38AM +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> Today's linux-next merge of the vfs tree got conflicts in fs/nfs/direct.c
> and fs/nfs/file.c between commits b9517433d65d ("dio: Convert direct_IO
> to use iov_iter"), a8431c667ae8 ("nfs: add support for read_iter,
> write_iter") and a1b8ec384b73 ("nfs: simplify swap") from the aio-direct
> tree and commit c18d1ec44f7a ("nfs: use %p[dD] instead of open-coded (and
> often racy) equivalents") from the vfs tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Hrm...  FWIW, I would greatly prefer to offload these printk patches to
NFS and NFSD trees.  Didn't get around to that yet, but...

As for aio-direct...  Two questions:
	* had anybody tried to measure the effect on branch predictor from
introducing that method vector?  Commit d6afd4c4 ("iov_iter: hide iovec
details behind ops function pointers")
	* WTF does aforementioned commit lack its author's s-o-b?  The same
goes for a lot of zab's commits in there...
