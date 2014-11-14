Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650AbaKNA24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:28:56 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33784 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993AbaKNA2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:28:55 -0500
Date: Thu, 13 Nov 2014 16:28:50 -0800
From: josh@joshtriplett.org
To: Pieter Smith <pieter@boesman.nl>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/56] fs/ext4: support compiling out splice
Message-ID: <20141114002850.GA31015@cloud>
References: <pieter@boesman.nl>
 <1415913813-362-1-git-send-email-pieter@boesman.nl>
 <1415913813-362-21-git-send-email-pieter@boesman.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415913813-362-21-git-send-email-pieter@boesman.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 10:22:57PM +0100, Pieter Smith wrote:
> Compile out splice support from ext4 when the splice-family of syscalls is not
> supported by the system (i.e. CONFIG_SYSCALL_SPLICE is undefined).
> 
> Signed-off-by: Pieter Smith <pieter@boesman.nl>

See below; you shouldn't need this or similar patches for most
filesystems at all.

>  fs/ext4/file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index aca7b24..c9d2962 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -595,8 +595,8 @@ const struct file_operations ext4_file_operations = {
>  	.open		= ext4_file_open,
>  	.release	= ext4_release_file,
>  	.fsync		= ext4_sync_file,
> -	.splice_read	= generic_file_splice_read,
> -	.splice_write	= iter_file_splice_write,
> +	SPLICE_READ_INIT(generic_file_splice_read)
> +	SPLICE_WRITE_INIT(iter_file_splice_write)

You can just define iter_file_splice_write as NULL when configuring out
splice.  You could almost do the same for generic_file_splice_read, but
a couple of implementations of filesystem-specific splice functions
actually call it; you can make it a no-op static inline, though.

- Josh Triplett
