Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbaJXPNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:13:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947AbaJXPNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:13:14 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/4] vfs: Prepare for adding a new preadv/pwritev with user flags.
References: <cover.1413923420.git.milosz@adfin.com>
	<cover.1413923420.git.milosz@adfin.com>
	<9306856a3ea74bcc41523430d74ef4be93d8f436.1413923420.git.milosz@adfin.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 24 Oct 2014 11:12:29 -0400
In-Reply-To: <9306856a3ea74bcc41523430d74ef4be93d8f436.1413923420.git.milosz@adfin.com>
	(Milosz Tanski's message of "Tue, 21 Oct 2014 16:46:56 -0400")
Message-ID: <x49a94lpkma.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> writes:

> Plumbing the flags argument through the vfs code so they can be passed down to
> __generic_file_(read/write)_iter function that do the acctual work.
                                                        ^^^^^^^
actual

> Signed-off-by: Milosz Tanski <milosz@adfin.com>

> diff --git a/fs/read_write.c b/fs/read_write.c
> index 7d9318c..9858c06 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
[...]
> @@ -1113,6 +1116,7 @@ COMPAT_SYSCALL_DEFINE5(preadv, compat_ulong_t, fd,
>  	return __compat_sys_preadv64(fd, vec, vlen, pos);
>  }
>  
> +
>  static size_t compat_writev(struct file *file,
>  			    const struct compat_iovec __user *vec,
>  			    unsigned long vlen, loff_t *pos)

Lose this hunk.


> diff --git a/mm/filemap.c b/mm/filemap.c
> index 14b4642..cb7f530 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1465,7 +1465,7 @@ static void shrink_readahead_size_eio(struct file *filp,
>   * of the logic when it comes to error handling etc.
>   */
>  static ssize_t do_generic_file_read(struct file *filp, loff_t *ppos,
> -		struct iov_iter *iter, ssize_t written)
> +		struct iov_iter *iter, ssize_t written, int flags)
>  {
>  	struct address_space *mapping = filp->f_mapping;
>  	struct inode *inode = mapping->host;

As Christoph mentioned, this belongs elsewhere.

Fix that up and you an add my:

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
