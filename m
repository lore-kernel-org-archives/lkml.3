Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaAaUw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:52:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbaAaUw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:52:58 -0500
Date: Fri, 31 Jan 2014 15:52:53 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix mountpoint reference leakage in linkat
Message-ID: <20140131155253.25a72413@tlielax.poochiereds.net>
In-Reply-To: <1391200918-29185-1-git-send-email-green@linuxhacker.ru>
References: <1391200918-29185-1-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 15:41:58 -0500
Oleg Drokin <green@linuxhacker.ru> wrote:

> Recent changes to retry on ESTALE in linkat
> (commit 442e31ca5a49e398351b2954b51f578353fdf210)
> introduced a mountpoint reference leak and a small memory
> leak in case a filesystem link operation returns ESTALE
> which is pretty normal for distributed filesystems like
> lustre, nfs and so on.
> Free old_path in such a case.
> 
> Signed-off-by: Oleg Drokin: <green@linuxhacker.ru>
> ---
>  fs/namei.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index bcb838e..e620937 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3931,6 +3931,7 @@ out_dput:
>  			goto retry;
>  	}
>  	if (retry_estale(error, how)) {
> +		path_put(&old_path);
>  		how |= LOOKUP_REVAL;
>  		goto retry;
>  	}

Nice catch. This should probably also go to stable as well...

Reviewed-by: Jeff Layton <jlayton@redhat.com>
