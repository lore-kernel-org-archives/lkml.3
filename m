Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423250Ab3CWCtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 22:49:17 -0400
Received: from mail04-md.ns.itscom.net ([175.177.155.114]:34500 "EHLO
	mail04-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422878Ab3CWCtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 22:49:16 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
        jack@suse.cz, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, sedat.dilek@googlemail.com, mszeredi@suse.cz
In-Reply-To: <20130322182107.GQ21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu> <1363184193-1796-1-git-send-email-miklos@szeredi.hu> <1944.1363525619@warthog.procyon.org.uk> <13789.1363973875@jrobl> <20130322181111.GP21522@ZenIV.linux.org.uk> <20130322182107.GQ21522@ZenIV.linux.org.uk>
Date: Sat, 23 Mar 2013 11:49:11 +0900
Message-ID: <23399.1364006951@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al Viro:
> The scenario, BTW, looks so:
> process A does sb_start_write() (on your upper layer)
> process B tries to freeze said upper layer and blocks, waiting for A to finish
> process C grabs ->i_mutex in your upper layer
> process C does vfs_write(), which blocks, since there's a pending attempt to
> freeze
> process A tries to grab ->i_mutex held by C and blocks

According to latest mm/filemap.c:generic_file_aio_write(),
	sb_start_write(inode->i_sb);
	mutex_lock(&inode->i_mutex);
	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
	mutex_unlock(&inode->i_mutex);
	:::
	sb_end_write(inode->i_sb);

Process C would block *BEFORE* i_mutex by sb_start_write()? No?
Honestly speaking I didn't pay attention about the freeze feature since
I don't use it. I am making aufs to support it now. But I don't know how
to test it...


J. R. Okajima
