Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbaHBQzv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 12:55:51 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:60180 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbaHBQzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 12:55:50 -0400
MIME-Version: 1.0
In-Reply-To: <1406413711-7798-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1406413711-7798-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sat, 2 Aug 2014 11:55:48 -0500
Message-ID: <CADT32eLts-tdQdHo+W3Zc1wQ6Qz8aS3TmHsm8OxmiF2fmhOW5g@mail.gmail.com>
Subject: Re: [PATCH] fs: cifs: cifsencrypt.c: Cleaning up missing
 null-terminate in conjunction with strncpy
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Steve French <sfrench@samba.org>, linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Shirish Pargaonkar <spargaonkar@suse.com>

On Sat, Jul 26, 2014 at 5:28 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> If you are going to use memset before strncpy you must copy sizeof -1
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  fs/cifs/cifsencrypt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 4934347..dcca8b3 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -307,7 +307,7 @@ int calc_lanman_hash(const char *password, const char *cryptkey, bool encrypt,
>
>         memset(password_with_pad, 0, CIFS_ENCPWD_SIZE);
>         if (password)
> -               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE);
> +               strncpy(password_with_pad, password, CIFS_ENCPWD_SIZE - 1);
>
>         if (!encrypt && global_secflags & CIFSSEC_MAY_PLNTXT) {
>                 memcpy(lnm_session_key, password_with_pad,
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
