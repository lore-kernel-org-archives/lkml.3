Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbbAISxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:53:52 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:56270 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbbAISxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:53:47 -0500
MIME-Version: 1.0
In-Reply-To: <1420580220-6276-1-git-send-email-me@mortis.eu>
References: <1420394744-20268-1-git-send-email-me@mortis.eu> <1420580220-6276-1-git-send-email-me@mortis.eu>
From: Steve French <smfrench@gmail.com>
Date: Fri, 9 Jan 2015 12:53:26 -0600
Message-ID: <CAH2r5mvyaZY6MpKCjPbhpV1q-QC_EB8p6i94OqAAUaG7gs5PKA@mail.gmail.com>
Subject: Re: [PATCH RESEND] cifs: use memzero_explicit to clear stack buffer
To: Giel van Schijndel <me@mortis.eu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steve French <sfrench@samba.org>,
        "open list:COMMON INTERNET F..." <linux-cifs@vger.kernel.org>,
        "moderated list:COMMON INTERNET F..." 
	<samba-technical@lists.samba.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks fine to me - will merge into cifs-2.6.git

On Tue, Jan 6, 2015 at 3:37 PM, Giel van Schijndel <me@mortis.eu> wrote:
> When leaving a function use memzero_explicit instead of memset(0) to
> clear stack allocated buffers. memset(0) may be optimized away.
>
> This particular buffer is highly likely to contain sensitive data which
> we shouldn't leak (it's named 'passwd' after all).
>
> Signed-off-by: Giel van Schijndel <me@mortis.eu>
> Reported-at: http://www.viva64.com/en/b/0299/
> Reported-by: Andrey Karpov
> Reported-by: Svyatoslav Razmyslov
> ---
>  fs/cifs/smbencrypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> index 6c15663..a4232ec 100644
> --- a/fs/cifs/smbencrypt.c
> +++ b/fs/cifs/smbencrypt.c
> @@ -221,7 +221,7 @@ E_md4hash(const unsigned char *passwd, unsigned char *p16,
>         }
>
>         rc = mdfour(p16, (unsigned char *) wpwd, len * sizeof(__le16));
> -       memset(wpwd, 0, 129 * sizeof(__le16));
> +       memzero_explicit(wpwd, sizeof(wpwd));
>
>         return rc;
>  }
> --
> 2.1.4
>



-- 
Thanks,

Steve
