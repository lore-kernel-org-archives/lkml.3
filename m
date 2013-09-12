Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab3ILNYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:24:23 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53411 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3ILNYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:24:19 -0400
MIME-Version: 1.0
Date: Thu, 12 Sep 2013 15:24:19 +0200
X-Google-Sender-Auth: _AN63R8ym1FvxvhsvekVJuPf69o
Message-ID: <CAMuHMdViO7yNJ5rxvRkv5NhmW6PQY1N+HW75NwokFnGQp+nxxw@mail.gmail.com>
Subject: Kernel size increase of +256 KiB (was: Re: RPCSEC_GSS: Share all
 credential caches on a per-transport basis)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 6:57 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
> index 5ec15bb..dc4b449 100644
> --- a/net/sunrpc/auth_gss/auth_gss.c
> +++ b/net/sunrpc/auth_gss/auth_gss.c
> @@ -51,6 +51,7 @@
>  #include <linux/sunrpc/rpc_pipe_fs.h>
>  #include <linux/sunrpc/gss_api.h>
>  #include <asm/uaccess.h>
> +#include <linux/hashtable.h>
>
>  #include "../netns.h"
>
> @@ -71,6 +72,9 @@ static unsigned int gss_expired_cred_retry_delay = GSS_RETRY_EXPIRED;
>   * using integrity (two 4-byte integers): */
>  #define GSS_VERF_SLACK         100
>
> +static DEFINE_HASHTABLE(gss_auth_hash_table, 16);
> +static DEFINE_SPINLOCK(gss_auth_hash_lock);

Today's m68k/atari-defconfig kernel no longer boots, as it became larger than
4 MiB.

bloat-o-meter tells me:

function                                     old     new   delta
gss_auth_hash_table                            -  262144 +262144

Woops...

Are you trying to game Tim's survey? ;-)
(question 13 at http://www.embeddedlinuxconference.com/cgi-bin/survey.cgi)

Can this memory be allocated dynamically / only when it's used?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
