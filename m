Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab3LILD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:03:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab3LILDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:03:23 -0500
Date: Mon, 9 Dec 2013 06:03:21 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Tim Gardner <timg@tpi.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
        Dean Gehnert <deang@tpi.com>
Subject: Re: [PATCH 4/5 linux-next V2] cifs: fix incorrect reference count
 check
Message-ID: <20131209060321.030be558@tlielax.poochiereds.net>
In-Reply-To: <1386536924-51726-4-git-send-email-timg@tpi.com>
References: <1386536924-51726-1-git-send-email-timg@tpi.com>
	<1386536924-51726-4-git-send-email-timg@tpi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  8 Dec 2013 14:08:43 -0700
Tim Gardner <timg@tpi.com> wrote:

> The reference count on tlink can only be decremented if
> cifs_sb_tlink(cifs_sb) was used to acquire it. That only
> happens if open_file==NULL.
> 
> Cc: Steve French <sfrench@samba.org>
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Dean Gehnert <deang@tpi.com>
> Signed-off-by: Tim Gardner <timg@tpi.com>
> ---
> 
> V2 - this is a new patch in the V2 series.
> 
>  fs/cifs/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 3f710c6..e332038 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2007,7 +2007,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
>  			CIFSSMBClose(xid, tcon, netfid);
>  		}
>  	}
> -	if (tlink)
> +	if (!open_file)
>  		cifs_put_tlink(tlink);
>  
>  set_size_out:


I don't see the bug here...

The only place tlink gets set to a non-NULL value is where
cifs_sb_tlink gets called. Am I missing something?

-- 
Jeff Layton <jlayton@redhat.com>
