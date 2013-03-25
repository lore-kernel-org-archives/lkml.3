Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab3CYERv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 00:17:51 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58485 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3CYERt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 00:17:49 -0400
MIME-Version: 1.0
In-Reply-To: <1362918544-31796-1-git-send-email-winged.flamespitter@gmail.com>
References: <1362918544-31796-1-git-send-email-winged.flamespitter@gmail.com>
Date: Sun, 24 Mar 2013 23:17:49 -0500
Message-ID: <CAH2r5ms73QumoAKFazs_=8L9i+7WGFWrNzYAQ3eJXxXDJGsiQA@mail.gmail.com>
Subject: Re: [PATCH] cifs: replaced kmalloc + memset with kzalloc
From: Steve French <smfrench@gmail.com>
To: Dia Vasile <winged.flamespitter@gmail.com>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
        Dia Vasile <kill.elohim@hotmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged into cifs-2.6.git for-next branch

On Sun, Mar 10, 2013 at 7:29 AM, Dia Vasile
<winged.flamespitter@gmail.com> wrote:
> From: Dia Vasile <kill.elohim@hotmail.com>
>
> Signed-off-by: Diana Vasile <kill.elohim@hotmail.com>
> ---
>  fs/cifs/smb2pdu.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 41d9d07..83ef66e 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -846,12 +846,10 @@ create_lease_buf(u8 *lease_key, u8 oplock)
>  {
>         struct create_lease *buf;
>
> -       buf = kmalloc(sizeof(struct create_lease), GFP_KERNEL);
> +       buf = kzalloc(sizeof(struct create_lease), GFP_KERNEL);
>         if (!buf)
>                 return NULL;
>
> -       memset(buf, 0, sizeof(struct create_lease));
> -
>         buf->lcontext.LeaseKeyLow = cpu_to_le64(*((u64 *)lease_key));
>         buf->lcontext.LeaseKeyHigh = cpu_to_le64(*((u64 *)(lease_key + 8)));
>         if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
> --
> 1.7.10.4
>



-- 
Thanks,

Steve
