Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaG1OSJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:18:09 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:38145 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaG1OSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <1406385895-3886-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1406385895-3886-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Mon, 28 Jul 2014 10:18:06 -0400
X-Google-Sender-Auth: Pee8uySqGoY-pefqJx-mlyiZ2j4
Message-ID: <CAGXu5jK9Fm9Yw4mNoSZ7+B3LyvTbWx5fyOcB46V8=J4kLa2d3Q@mail.gmail.com>
Subject: Re: [PATCH] kernel: debug: kdb: kdb_io.c: Cleaning up missing
 null-terminate in conjunction with strncpy
From: Kees Cook <keescook@chromium.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, Randy Dunlap <rdunlap@infradead.org>,
        kgdb-bugreport@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 10:44 AM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  kernel/debug/kdb/kdb_io.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
> index 7c70812..27977c0 100644
> --- a/kernel/debug/kdb/kdb_io.c
> +++ b/kernel/debug/kdb/kdb_io.c
> @@ -361,9 +361,9 @@ poll_again:
>                         kdb_printf("%s", buffer);
>                 } else if (tab != 2 && count > 0) {
>                         len_tmp = strlen(p_tmp);
> -                       strncpy(p_tmp+len_tmp, cp, lastchar-cp+1);
> +                       strlcpy(p_tmp+len_tmp, cp, lastchar-cp+1);
>                         len_tmp = strlen(p_tmp);
> -                       strncpy(cp, p_tmp+len, len_tmp-len + 1);
> +                       strlcpy(cp, p_tmp+len, len_tmp-len + 1);
>                         len = len_tmp - len;
>                         kdb_printf("%s", cp);
>                         cp += len;

It's not clear to me what this code is actually doing, but I think the
"+1" parts to these strncpy()s are there to include the NULL
character.

> @@ -442,7 +442,7 @@ poll_again:
>  char *kdb_getstr(char *buffer, size_t bufsize, char *prompt)
>  {
>         if (prompt && kdb_prompt_str != prompt)
> -               strncpy(kdb_prompt_str, prompt, CMD_BUFLEN);
> +               strlcpy(kdb_prompt_str, prompt, CMD_BUFLEN);

This seems like a good idea.

>         kdb_printf(kdb_prompt_str);
>         kdb_nextline = 1;       /* Prompt and input resets line number */
>         return kdb_read(buffer, bufsize);
> --
> 1.7.10.4
>

-Kees

-- 
Kees Cook
Chrome OS Security
