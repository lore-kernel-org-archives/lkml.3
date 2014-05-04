Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaEDBIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:08:19 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:62277 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaEDBIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:08:18 -0400
Date: Sat, 3 May 2014 21:08:02 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs/locks.c: replace seq_printf by seq_puts
Message-ID: <20140503210802.6d4fc746@ipyr.poochiereds.net>
In-Reply-To: <20140503222843.771ebf5e7ce18243fd2a5c30@skynet.be>
References: <20140503222843.771ebf5e7ce18243fd2a5c30@skynet.be>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2014 22:28:43 +0200
Fabian Frederick <fabf@skynet.be> wrote:

> Replace seq_printf where possible
> 
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/locks.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index e663aea..78ac209 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -2411,31 +2411,31 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
>  	seq_printf(f, "%lld:%s ", id, pfx);
>  	if (IS_POSIX(fl)) {
>  		if (fl->fl_flags & FL_ACCESS)
> -			seq_printf(f, "ACCESS");
> +			seq_puts(f, "ACCESS");
>  		else if (IS_OFDLCK(fl))
> -			seq_printf(f, "OFDLCK");
> +			seq_puts(f, "OFDLCK");
>  		else
> -			seq_printf(f, "POSIX ");
> +			seq_puts(f, "POSIX ");
>  
>  		seq_printf(f, " %s ",
>  			     (inode == NULL) ? "*NOINODE*" :
>  			     mandatory_lock(inode) ? "MANDATORY" : "ADVISORY ");
>  	} else if (IS_FLOCK(fl)) {
>  		if (fl->fl_type & LOCK_MAND) {
> -			seq_printf(f, "FLOCK  MSNFS     ");
> +			seq_puts(f, "FLOCK  MSNFS     ");
>  		} else {
> -			seq_printf(f, "FLOCK  ADVISORY  ");
> +			seq_puts(f, "FLOCK  ADVISORY  ");
>  		}
>  	} else if (IS_LEASE(fl)) {
> -		seq_printf(f, "LEASE  ");
> +		seq_puts(f, "LEASE  ");
>  		if (lease_breaking(fl))
> -			seq_printf(f, "BREAKING  ");
> +			seq_puts(f, "BREAKING  ");
>  		else if (fl->fl_file)
> -			seq_printf(f, "ACTIVE    ");
> +			seq_puts(f, "ACTIVE    ");
>  		else
> -			seq_printf(f, "BREAKER   ");
> +			seq_puts(f, "BREAKER   ");
>  	} else {
> -		seq_printf(f, "UNKNOWN UNKNOWN  ");
> +		seq_puts(f, "UNKNOWN UNKNOWN  ");
>  	}
>  	if (fl->fl_type & LOCK_MAND) {
>  		seq_printf(f, "%s ",
> @@ -2467,7 +2467,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
>  		else
>  			seq_printf(f, "%Ld %Ld\n", fl->fl_start, fl->fl_end);
>  	} else {
> -		seq_printf(f, "0 EOF\n");
> +		seq_puts(f, "0 EOF\n");
>  	}
>  }
>  

Looks good to me. I'll plan to merge it for v3.16.

Thanks!
-- 
Jeff Layton <jlayton@poochiereds.net>
