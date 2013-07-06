Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3GFKrL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 06:47:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:57890 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002Ab3GFKrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 06:47:08 -0400
Date: Sat, 06 Jul 2013 19:45:21 +0900 (JST)
Message-Id: <20130706.194521.326433844.konishi.ryusuke@lab.ntt.co.jp>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-nilfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v5 11/12] nilfs2: replace direct access of d_count with
 the d_count() helper
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <1373035709-40875-1-git-send-email-Waiman.Long@hp.com>
References: <1373035709-40875-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (sh.osrg.net [192.16.179.4]); Sat, 06 Jul 2013 19:45:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Jul 2013 10:48:29 -0400, Waiman Long <Waiman.Long@hp.com> wrote:
> Because of the d_count change made in dcache.h, all readonly references
> to d_count have to be changed to use the new d_count() helper as they
> shouldn't access its value directly.  There is no change in logic
> and everything should just work.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>


Thanks,
Ryusuke Konishi

> ---
>  fs/nilfs2/super.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
> index c7d1f9f..bd9d1f2 100644
> --- a/fs/nilfs2/super.c
> +++ b/fs/nilfs2/super.c
> @@ -973,7 +973,7 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
>  
>  static int nilfs_tree_was_touched(struct dentry *root_dentry)
>  {
> -	return root_dentry->d_count > 1;
> +	return d_count(root_dentry) > 1;
>  }
>  
>  /**
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
