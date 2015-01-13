Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbbAMRTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:19:15 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46104 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbbAMRTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:19:13 -0500
MIME-Version: 1.0
In-Reply-To: <20150113163832.24625.95960.stgit@warthog.procyon.org.uk>
References: <20150113163832.24625.95960.stgit@warthog.procyon.org.uk>
Date: Tue, 13 Jan 2015 13:19:13 -0400
Message-ID: <CAB9dFdvPM-qbhPOZ=4KLs2OB5PYSzaog6byzCvV8N-72uxJ5cQ@mail.gmail.com>
Subject: Re: [PATCH] VFS: Convert file->f_dentry->d_inode to file_inode()
From: Marc Dionne <marc.c.dionne@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: jesper.nilsson@axis.com, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 12:38 PM, David Howells <dhowells@redhat.com> wrote:
> Convert file->f_dentry->d_inode to file_inode() so as to get layered
> filesystems right.
>
> Found with: git grep '[.>]f_dentry'
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  arch/cris/arch-v32/drivers/sync_serial.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
> index 08a313fc2241..e9b6de2b46a0 100644
> --- a/arch/cris/arch-v32/drivers/sync_serial.c
> +++ b/arch/cris/arch-v32/drivers/sync_serial.c
> @@ -604,7 +604,7 @@ static ssize_t __sync_serial_read(struct file *file,
>                                   struct timespec *ts)
>  {
>         unsigned long flags;
> -       int dev = MINOR(file->f_dentry->d_inode->i_rdev);
> +       int dev = MINOR(file_inode(file_inode)->i_rdev);

Shouldn't that be file_inode(file) ?

>         int avail;
>         struct sync_port *port;
>         unsigned char *start;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Marc
