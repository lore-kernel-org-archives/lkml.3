Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbbAEJZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:25:42 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:37522 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbbAEJZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:25:40 -0500
MIME-Version: 1.0
In-Reply-To: <1420131512-30585-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1420131512-30585-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 5 Jan 2015 12:25:39 +0300
Message-ID: <CALFYKtDj+0aWe+vR2pCVCp_E=UDBuLkkPtH0f_14Hx8HBP0v7g@mail.gmail.com>
Subject: Re: [PATCH] block: rbd.c: Remove unused function
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Yehuda Sadeh <yehuda@inktank.com>, Sage Weil <sage@inktank.com>,
        Alex Elder <elder@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 1, 2015 at 7:58 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Remove the function copy_token() that is not used anywhere.
>
> This was partially found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/block/rbd.c |   30 ------------------------------
>  1 file changed, 30 deletions(-)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 27b71a0..922f1ab 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -4776,36 +4776,6 @@ static inline size_t next_token(const char **buf)
>  }
>
>  /*
> - * Finds the next token in *buf, and if the provided token buffer is
> - * big enough, copies the found token into it.  The result, if
> - * copied, is guaranteed to be terminated with '\0'.  Note that *buf
> - * must be terminated with '\0' on entry.
> - *
> - * Returns the length of the token found (not including the '\0').
> - * Return value will be 0 if no token is found, and it will be >=
> - * token_size if the token would not fit.
> - *
> - * The *buf pointer will be updated to point beyond the end of the
> - * found token.  Note that this occurs even if the token buffer is
> - * too small to hold it.
> - */
> -static inline size_t copy_token(const char **buf,
> -                               char *token,
> -                               size_t token_size)
> -{
> -        size_t len;
> -
> -       len = next_token(buf);
> -       if (len < token_size) {
> -               memcpy(token, *buf, len);
> -               *(token + len) = '\0';
> -       }
> -       *buf += len;
> -
> -        return len;
> -}
> -
> -/*
>   * Finds the next token in *buf, dynamically allocates a buffer big
>   * enough to hold a copy of it, and copies the token into the new
>   * buffer.  The copy is guaranteed to be terminated with '\0'.  Note

Applied with an amended changelog.

Thanks,

                Ilya
