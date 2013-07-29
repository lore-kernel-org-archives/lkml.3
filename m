Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab3G2UUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 16:20:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab3G2UUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 16:20:36 -0400
Date: Mon, 29 Jul 2013 16:20:16 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Andi Shyti <andi@etezian.org>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikko.rapeli@iki.fi,
        pshilovsky@samba.org
Subject: Re: [PATCH v2] cifs: file: initialize oparms.reconnect before using
 it
Message-ID: <20130729162016.3299ead3@tlielax.poochiereds.net>
In-Reply-To: <1375121075-11239-1-git-send-email-andi@etezian.org>
References: <20130729093241.437315e1@corrin.poochiereds.net>
	<1375121075-11239-1-git-send-email-andi@etezian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013 20:04:35 +0200
Andi Shyti <andi@etezian.org> wrote:

> In the cifs_reopen_file function, if the following statement is
> asserted:
> 
> (tcon->unix_ext && cap_unix(tcon->ses) &&
>             (CIFS_UNIX_POSIX_PATH_OPS_CAP &
>             (tcon->fsUnixInfo.Capability)))
> 
> and we succeed to open with cifs_posix_open, the function jumps
> to the label reopen_success and checks for oparms.reconnect
> which is not initialized.
> 
> This issue has been reported by scan.coverity.com
> 
> Signed-off-by: Andi Shyti <andi@etezian.org>
> ---
>  fs/cifs/file.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 1e57f36..7e36ae3 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -647,6 +647,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
>  				     oflags, &oplock, &cfile->fid.netfid, xid);
>  		if (rc == 0) {
>  			cifs_dbg(FYI, "posix reopen succeeded\n");
> +			oparms.reconnect = true;
>  			goto reopen_success;
>  		}
>  		/*

Still doesn't do much to improve this code, but that fix shouldn't
break anything.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
