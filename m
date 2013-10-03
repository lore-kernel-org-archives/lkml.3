Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab3JCKcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:32:35 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:47637 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab3JCKcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:32:32 -0400
Date: Thu, 3 Oct 2013 12:33:15 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] fuse: writepages: protect secondary requests from
 fuse file release
Message-ID: <20131003103315.GD14242@tucsk.piliscsaba.szeredi.hu>
References: <20131002173701.31188.33547.stgit@dhcp-10-30-17-2.sw.ru>
 <20131002173848.31188.77211.stgit@dhcp-10-30-17-2.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002173848.31188.77211.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 09:38:54PM +0400, Maxim Patlasov wrote:
> All async fuse requests must be supplied with extra reference to a fuse file.
> This is necessary to ensure that the fuse file is not released until all
> in-flight requests are completed. Fuse secondary writeback requests must
> obey this rule as well.

Okay, applied.

Thanks,
Miklos

> 
> Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
> ---
>  fs/fuse/file.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 5d323bd..266a792 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -1521,6 +1521,7 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
>  			continue;
>  		}
>  
> +		next->ff = fuse_file_get(req->ff);
>  		list_add(&next->writepages_entry, &fi->writepages);
>  		list_add_tail(&next->list, &fi->queued_writes);
>  		fuse_flush_writepages(inode);
> 
