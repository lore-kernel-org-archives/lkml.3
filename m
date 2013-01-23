Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab3AWBgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:36:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab3AWBgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:36:08 -0500
Date: Tue, 22 Jan 2013 20:36:03 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/cifs/cifs_dfs_ref.c: fix potential memory leakage
Message-ID: <20130122203603.1bd26363@corrin.poochiereds.net>
In-Reply-To: <1358900459-26277-1-git-send-email-dinggnu@gmail.com>
References: <1358900459-26277-1-git-send-email-dinggnu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013 19:20:58 -0500
Cong Ding <dinggnu@gmail.com> wrote:

> When it goes to error through line 144, the memory allocated to *devname is
> not freed, and the caller doesn't free it either in line 250. So we free the
> memroy of *devname in function cifs_compose_mount_options() when it goes to
> error.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  fs/cifs/cifs_dfs_ref.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index ce5cbd7..210fce2 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -226,6 +226,8 @@ compose_mount_options_out:
>  compose_mount_options_err:
>  	kfree(mountdata);
>  	mountdata = ERR_PTR(rc);
> +	kfree(*devname);
> +	*devname = NULL;
>  	goto compose_mount_options_out;
>  }
>  

Nice catch. Looks correct to me. Should this also go to stable?

Reviewed-by: Jeff Layton <jlayton@redhat.com>
