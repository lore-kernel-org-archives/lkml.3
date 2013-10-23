Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3JWJ63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:58:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58649 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab3JWJ6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:58:25 -0400
Date: Wed, 23 Oct 2013 11:50:40 +0200
From: Jan Kara <jack@suse.cz>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: viro@zeniv.linux.org.uk, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com,
        marco.stornelli@gmail.com, jack@suse.cz
Subject: Re: [PATCH] reiserfs: remove duplicate define
Message-ID: <20131023095040.GD1275@quack.suse.cz>
References: <1382342097-2991-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382342097-2991-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 21-10-13 09:54:57, Michael Opdenacker wrote:
> This patch removes a duplicate define in fs/reiserfs/reiserfs.h
  Hum, so the duplicate define certainly isn't nice but it's really a
result of a namespace collision between return codes of two different (sets
of) functions. So deleting the duplicate isn't really solving the problem,
just hiding it. So I'd prefer more one of the following two solutions:
1) Just ignore the problem. Reiserfs is mostly dead and this isn't likely to
cause any subtle issues.
2) Prefix the return codes somehow so that those two error namespaces don't
clash. As a bonus you can convert defines to enums but I'm not sure that's
worth the bother (prefixing is a simple search & replace so that should be
trivial, well except for the CARRY_ON case).

								Honza
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  fs/reiserfs/reiserfs.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
> index f8adaee..a27d69b 100644
> --- a/fs/reiserfs/reiserfs.h
> +++ b/fs/reiserfs/reiserfs.h
> @@ -597,7 +597,6 @@ void reiserfs_file_buffer(struct buffer_head *bh, int list);
>  extern struct file_system_type reiserfs_fs_type;
>  int reiserfs_resize(struct super_block *, unsigned long);
>  
> -#define CARRY_ON                0
>  #define SCHEDULE_OCCURRED       1
>  
>  #define SB_BUFFER_WITH_SB(s) (REISERFS_SB(s)->s_sbh)
> -- 
> 1.8.1.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
