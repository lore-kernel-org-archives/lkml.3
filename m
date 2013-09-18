Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab3IRPT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:19:27 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45045 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3IRPTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:19:25 -0400
MIME-Version: 1.0
In-Reply-To: <1379335925-30858-6-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
	<1379335925-30858-6-git-send-email-miklos@szeredi.hu>
Date: Wed, 18 Sep 2013 10:19:20 -0500
Message-ID: <CAH2r5mt8gnJs1ji==oF6wVv2hFXjCbbZ4quRY9Xum3Fx1UA_bw@mail.gmail.com>
Subject: Re: [PATCH 05/11] cifs: fix filp leak in cifs_atomic_open()
From: Steve French <smfrench@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, mszeredi@suse.cz,
        Steve French <sfrench@samba.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you want me to merge this via my tree (cifs-2.6.git) or another?

On Mon, Sep 16, 2013 at 7:51 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> If an error occurs after having called finish_open() then fput() needs to
> be called on the already opened file.
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Steve French <sfrench@samba.org>
> Cc: stable@vger.kernel.org
> ---
>  fs/cifs/dir.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index d3e2eaa..5384c2a 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -500,6 +500,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
>                 if (server->ops->close)
>                         server->ops->close(xid, tcon, &fid);
>                 cifs_del_pending_open(&open);
> +               fput(file);
>                 rc = -ENOMEM;
>         }
>
> --
> 1.8.1.4
>



-- 
Thanks,

Steve
