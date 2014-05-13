Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760910AbaEMOGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:06:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760678AbaEMOGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:06:04 -0400
Date: Tue, 13 May 2014 07:05:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Mikulas Patocka <mpatocka@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Joern Engel <joern@logfs.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Bob Copeland <me@bobcopeland.com>,
        Christoph Hellwig <hch@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] vfs: add noreplace_rename2()
Message-ID: <20140513140557.GA30660@infradead.org>
References: <20140513135622.GB17233@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140513135622.GB17233@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 03:56:22PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> RENAME_NOREPLACE is trivial to implement for most filesystems.  This adds a
> helper that can be assigned to ->rename2() and calls ->rename().
> 
> Only suitable for local filesystems, i.e. those that cannot have files
> "spontaneously" appear (like NFS and friends).

I don't like this approach at all.  Please bite the bullet and rename
->rename2 to ->rename and all the proper rejecting of non-supported
flags intstead of further locking down the duplication.

