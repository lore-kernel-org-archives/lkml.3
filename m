Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab3BLToV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 14:44:21 -0500
Received: from atl4mhob14.myregisteredsite.com ([209.17.115.52]:40627 "EHLO
	atl4mhob14.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933161Ab3BLToU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 14:44:20 -0500
X-Greylist: delayed 1297 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2013 14:44:20 EST
Date: Tue, 12 Feb 2013 14:44:14 -0500 (EST)
From: "nyc@holomorphy.com" <nyc@holomorphy.com>
Reply-To: "nyc@holomorphy.com" <nyc@holomorphy.com>
To: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org
Message-ID: <107362051.218193.1360698254858.JavaMail.vpopmail@mail.holomorphy.com>
In-Reply-To: <1360693071-61227-1-git-send-email-tim.gardner@canonical.com>
References: <1360693071-61227-1-git-send-email-tim.gardner@canonical.com>
Subject: Re: [PATCH linux-next] hugetlbfs: hugetlbfs_fill_super(): remove
 kfree() redundant null check
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v6.20.5-Rev1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Nadia Yvette Chambers <nyc@holomorphy.com>


On February 12, 2013 at 1:17 PM Tim Gardner <tim.gardner@canonical.com> wrote:

> smatch analysis:
>
> fs/hugetlbfs/inode.c:883 hugetlbfs_fill_super() info: redundant null check on
> sbinfo->spool calling kfree()
>
> Cc: Nadia Yvette Chambers <nyc@holomorphy.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  fs/hugetlbfs/inode.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 78bde32..e2e36ef 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -879,8 +879,7 @@ hugetlbfs_fill_super(struct super_block *sb, void *data,
> int silent)
>                  goto out_free;
>          return 0;
>  out_free:
> -        if (sbinfo->spool)
> -                kfree(sbinfo->spool);
> +        kfree(sbinfo->spool);
>          kfree(sbinfo);
>          return -ENOMEM;
>  }
> --
> 1.7.9.5
>
