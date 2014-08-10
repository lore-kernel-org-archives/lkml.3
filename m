Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaHJTLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 15:11:33 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:54928 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaHJTLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 15:11:31 -0400
MIME-Version: 1.0
In-Reply-To: <1405979256-8921-1-git-send-email-vincent.stehle@laposte.net>
References: <1405979256-8921-1-git-send-email-vincent.stehle@laposte.net>
From: Steve French <smfrench@gmail.com>
Date: Sun, 10 Aug 2014 14:11:10 -0500
Message-ID: <CAH2r5muS3xz3naupKAVtx3ob+3OUON1uu+QifRLKW4C=mS9mNw@mail.gmail.com>
Subject: Re: [PATCH linux-next] cifs: remove unused function cifs_oplock_break_wait
To: =?UTF-8?Q?Vincent_Stehl=C3=A9?= <vincent.stehle@laposte.net>
Cc: linux-next@vger.kernel.org,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Jul 21, 2014 at 4:47 PM, Vincent Stehlé
<vincent.stehle@laposte.net> wrote:
> Commit 743162013d40 ("sched: Remove proliferation of wait_on_bit() action
> functions") has removed the call to cifs_oplock_break_wait, making this
> function unused; remove it.
>
> This fixes the following compilation warning:
>
>   fs/cifs/misc.c:578:1: warning: ‘cifs_oplock_break_wait’ defined but not used [-Wunused-function]
>
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Steve French <sfrench@samba.org>
> ---
>
> Hi,
>
> This can be seen with e.g. linux next-20140721 and arm allmodconfig.
>
> Best regards,
>
> V.
>
>  fs/cifs/misc.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 9a70792..65c2682 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -574,13 +574,6 @@ void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
>                 cinode->oplock = 0;
>  }
>
> -static int
> -cifs_oplock_break_wait(void *unused)
> -{
> -       schedule();
> -       return signal_pending(current) ? -ERESTARTSYS : 0;
> -}
> -
>  /*
>   * We wait for oplock breaks to be processed before we attempt to perform
>   * writes.
> --
> 2.0.1
>



-- 
Thanks,

Steve
