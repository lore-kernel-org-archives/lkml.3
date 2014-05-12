Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaELDY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:24:28 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:50123 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaELDY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:24:27 -0400
MIME-Version: 1.0
In-Reply-To: <20140510190616.5b2f08be29de98e9cb065fd2@skynet.be>
References: <20140510190616.5b2f08be29de98e9cb065fd2@skynet.be>
Date: Mon, 12 May 2014 11:24:26 +0800
Message-ID: <CACVXFVPsBaie2UXEgR53dOr8JJ=O-6o2Fk6V9us161h7UydkUg@mail.gmail.com>
Subject: Re: [PATCH V4 2/2] fs/ext4/fsync.c: generic_file_fsync call based on
 barrier flag
From: Ming Lei <tom.leiming@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jack <jack@suse.cz>,
        hch <hch@infradead.org>, Viro <viro@zeniv.linux.org.uk>,
        tytso <tytso@mit.edu>, akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 1:06 AM, Fabian Frederick <fabf@skynet.be> wrote:
> generic_file_fsync has been updated to issue a flush for
> older filesystems.
>
> This patch tests for barrier flag in ext4 mount flags
> and calls the right function.
>
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/ext4/fsync.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index a8bc47f..fa82c0a 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -108,6 +108,10 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>
>         if (!journal) {
>                 ret = generic_file_fsync(file, start, end, datasync);

Forget to remove above line?

> +               if (test_opt(inode->i_sb, BARRIER))
> +                       ret = generic_file_fsync(file, start, end, datasync);
> +               else
> +                       ret = __generic_file_fsync(file, start, end, datasync);
>                 if (!ret && !hlist_empty(&inode->i_dentry))
>                         ret = ext4_sync_parent(inode);
>                 goto out;



Thanks,
-- 
Ming Lei
