Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaKKTsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:48:03 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59059 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaKKTsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:48:01 -0500
MIME-Version: 1.0
X-Originating-IP: [76.119.162.148]
In-Reply-To: <20141104102712.GA7088@tucsk.piliscsaba.szeredi.hu>
References: <20141104102712.GA7088@tucsk.piliscsaba.szeredi.hu>
Date: Tue, 11 Nov 2014 14:47:59 -0500
Message-ID: <CAHC9VhSrsf6nDWHSA10C-RjUy49DtquYn8TEtZ99dTN=nEdBZw@mail.gmail.com>
Subject: Re: [PATCH] audit_tree: keep inode pinned
From: Paul Moore <paul@paul-moore.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com, rgb@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2014 at 5:27 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Audit rules disappear when an inode they watch is evicted from the cache.
> This is likely not what we want.
>
> The guilty commit is "fsnotify: allow marks to not pin inodes in core",
> which didn't take into account that audit_tree adds watches with a zero
> mask.
>
> Adding any mask should fix this.
>
> Fixes: 90b1e7a57880 ("fsnotify: allow marks to not pin inodes in core")
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: stable@vger.kernel.org # 2.6.36+
> ---
>  kernel/audit_tree.c |    1 +
>  1 file changed, 1 insertion(+)

Thanks for your help on this, I've merged this into the audit
stable-3.18 branch; I plan on pushing this to Linus later this week.

 * git://git.infradead.org/users/pcmoore/audit stable-3.18

> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -154,6 +154,7 @@ static struct audit_chunk *alloc_chunk(i
>                 chunk->owners[i].index = i;
>         }
>         fsnotify_init_mark(&chunk->mark, audit_tree_destroy_watch);
> +       chunk->mark.mask = FS_IN_IGNORED;
>         return chunk;
>  }

-- 
paul moore
www.paul-moore.com
