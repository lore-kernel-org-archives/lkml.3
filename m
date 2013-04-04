Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070Ab3DDMdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:33:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759756Ab3DDMdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:33:49 -0400
Date: Thu, 4 Apr 2013 14:33:47 +0200
From: Jan Kara <jack@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: linux-next: manual merge of the akpm tree with the vfs tree
Message-ID: <20130404123347.GB26535@quack.suse.cz>
References: <20130404171211.3d359e39ca54e074f122d541@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404171211.3d359e39ca54e074f122d541@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-04-13 17:12:11, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got conflicts in mm/filemap.c,
> fs/xfs/xfs_file.c, fs/splice.c, fs/ocfs2/file.c, fs/ntfs/file.c,
> fs/fuse/file.c, fs/cifs/file.c and fs/btrfs/file.c between commit
> 36bd5dc0c4e2 ("lift sb_start_write/sb_end_write out of ->aio_write()")
> from the vfs tree and commit "fs: return EAGAIN when O_NONBLOCK write
> should block on frozen fs" from the akpm tree.
> 
> The former was removing the code modified by the letter, so I just
> dropped the akpm tree patch and the following "ocfs2: add freeze
> protection to ocfs2_file_splice_write()".
  Yeah, Al has been changing the area significantly. Andrew, you can drop
the three relevant patches from -mm since they'll have to be redone. ocfs2
should be actually fixed by Al's changes, psacct freeze remains but fixing
it will become trivial...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
