Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab3JNCZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 22:25:52 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:38470 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab3JNCZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 22:25:50 -0400
MIME-Version: 1.0
In-Reply-To: <1381692543-41226-1-git-send-email-tim.gardner@canonical.com>
References: <1381692543-41226-1-git-send-email-tim.gardner@canonical.com>
Date: Sun, 13 Oct 2013 21:25:50 -0500
Message-ID: <CAH2r5mvduivP8vddnZ8ybCZZ1=48NmMCb1gonOXe=D8aRJW_uQ@mail.gmail.com>
Subject: Re: [PATCH 3.12-rc4] cifs: ntstatus_to_dos_map[] is not terminated
From: Steve French <smfrench@gmail.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, Steve French <sfrench@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged into cifs-2.6.git

(for-next and for-linus branches)

Thoughts about suitability for stable anyone?

On Sun, Oct 13, 2013 at 2:29 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Functions that walk the ntstatus_to_dos_map[] array could
> run off the end. For example, ntstatus_to_dos() loops
> while ntstatus_to_dos_map[].ntstatus is not 0. Granted,
> this is mostly theoretical, but could be used as a DOS attack
> if the error code in the SMB header is bogus.
>
> Cc: Steve French <sfrench@samba.org>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  fs/cifs/netmisc.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index af847e1..651a527 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -780,7 +780,9 @@ static const struct {
>         ERRDOS, ERRnoaccess, 0xc0000290}, {
>         ERRDOS, ERRbadfunc, 0xc000029c}, {
>         ERRDOS, ERRsymlink, NT_STATUS_STOPPED_ON_SYMLINK}, {
> -       ERRDOS, ERRinvlevel, 0x007c0001}, };
> +       ERRDOS, ERRinvlevel, 0x007c0001}, {
> +       0, 0, 0 }
> +};
>
>  /*****************************************************************************
>   Print an error message from the status code
> --
> 1.7.9.5
>



-- 
Thanks,

Steve
