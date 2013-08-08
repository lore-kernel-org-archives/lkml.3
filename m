Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955Ab3HHHjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 03:39:16 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:39513 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852Ab3HHHjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 03:39:15 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2013 03:39:15 EDT
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/ctyTl8BqIsDL5g97U4vdEhaSWYOuUowG+zme+s2ntT3eUiyrneA==
X-RZG-CLASS-ID: mo05
Message-ID: <520349BA.8080006@gmx.net>
Date: Thu, 08 Aug 2013 09:33:14 +0200
From: Arne Jansen <sensille@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Sergei Trofimovich <slyich@gmail.com>
CC: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 6/7] btrfs: cleanup: removed unused 'btrfs_reada_detach'
References: <1375911803-17318-1-git-send-email-slyich@gmail.com> <1375911803-17318-7-git-send-email-slyich@gmail.com>
In-Reply-To: <1375911803-17318-7-git-send-email-slyich@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.08.2013 23:43, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Found by uselex.rb:
>> btrfs_reada_detach: [R]: exported from: fs/btrfs/btrfs.o fs/btrfs/built-in.o fs/btrfs/reada.o

even though the function is currently unused, I'm hesitating to remove it
as it's part of the reada-API and might be handy for anyone going to use
the API in the future.

-Arne

> 
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> ---
>  fs/btrfs/ctree.h | 1 -
>  fs/btrfs/reada.c | 9 +--------
>  2 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index e91ab9e..f35e086 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3861,7 +3861,6 @@ struct reada_control {
>  struct reada_control *btrfs_reada_add(struct btrfs_root *root,
>  			      struct btrfs_key *start, struct btrfs_key *end);
>  int btrfs_reada_wait(void *handle);
> -void btrfs_reada_detach(void *handle);
>  int btree_readahead_hook(struct btrfs_root *root, struct extent_buffer *eb,
>  			 u64 start, int err);
>  
> diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
> index 1031b69..c41d470 100644
> --- a/fs/btrfs/reada.c
> +++ b/fs/btrfs/reada.c
> @@ -37,7 +37,7 @@
>   * To trigger a readahead, btrfs_reada_add must be called. It will start
>   * a read ahead for the given range [start, end) on tree root. The returned
>   * handle can either be used to wait on the readahead to finish
> - * (btrfs_reada_wait), or to send it to the background (btrfs_reada_detach).
> + * (btrfs_reada_wait).
>   *
>   * The read ahead works as follows:
>   * On btrfs_reada_add, the root of the tree is inserted into a radix_tree.
> @@ -979,10 +979,3 @@ int btrfs_reada_wait(void *handle)
>  	return 0;
>  }
>  #endif
> -
> -void btrfs_reada_detach(void *handle)
> -{
> -	struct reada_control *rc = handle;
> -
> -	kref_put(&rc->refcnt, reada_control_release);
> -}

