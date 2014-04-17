Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaDQEK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 00:10:26 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:52714 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaDQEKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 00:10:24 -0400
MIME-Version: 1.0
In-Reply-To: <1397549210-29445-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1397549210-29445-1-git-send-email-michael.opdenacker@free-electrons.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 16 Apr 2014 23:10:03 -0500
Message-ID: <CAH2r5mt2CZi039PMfb52-3yEcny9ZpCVZXaYxWAg=nbNgywL9g@mail.gmail.com>
Subject: Re: [PATCH] cif: fix dead code
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git

On Tue, Apr 15, 2014 at 3:06 AM, Michael Opdenacker
<michael.opdenacker@free-electrons.com> wrote:
> This issue was found by Coverity (CID 1202536)
>
> This proposes a fix for a statement that creates dead code.
> The "rc < 0" statement is within code that is run
> with "rc > 0".
>
> It seems like "err < 0" was meant to be used here.
> This way, the error code is returned by the function.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  fs/cifs/file.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 8add25538a3b..b6e78632fa97 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2599,7 +2599,7 @@ cifs_writev(struct kiocb *iocb, const struct iovec *iov,
>                         ssize_t err;
>
>                         err = generic_write_sync(file, iocb->ki_pos - rc, rc);
> -                       if (rc < 0)
> +                       if (err < 0)
>                                 rc = err;
>                 }
>         } else {
> --
> 1.8.3.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
