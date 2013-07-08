Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab3GHNJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:09:53 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35572 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3GHNJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:09:52 -0400
MIME-Version: 1.0
In-Reply-To: <1371926227-2609-2-git-send-email-keescook@chromium.org>
References: <1371926227-2609-1-git-send-email-keescook@chromium.org>
	<1371926227-2609-2-git-send-email-keescook@chromium.org>
Date: Mon, 8 Jul 2013 06:09:50 -0700
X-Google-Sender-Auth: uuGTVi6NH7iuxi1NNL8cgTl_Tp4
Message-ID: <CAGXu5jKrW4t0HxBiinYTQs9eun_Z+bkNCjKgM_RYaL6Vz1PsoA@mail.gmail.com>
Subject: Re: [PATCH 1/4] lkdtm: fix stack protector trigger
From: Kees Cook <keescook@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ankita Garg <ankita@in.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to get this series added to lkdtm. Can someone take a moment
to review or ack them?

Thanks,

-Kees

On Sat, Jun 22, 2013 at 11:37 AM, Kees Cook <keescook@chromium.org> wrote:
> The -fstack-protector compiler flag will only build stack protections if
> a character array is seen. Additionally, the offset to the saved
> instruction pointer changes based on architecture, so stomp much harder
> (64 bytes) when corrupting the stack.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/misc/lkdtm.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
> index 08aad69..adb6bde 100644
> --- a/drivers/misc/lkdtm.c
> +++ b/drivers/misc/lkdtm.c
> @@ -295,10 +295,10 @@ static void lkdtm_do_action(enum ctype which)
>                 (void) recursive_loop(0);
>                 break;
>         case CT_CORRUPT_STACK: {
> -               volatile u32 data[8];
> -               volatile u32 *p = data;
> +               /* Make sure the compiler creates and uses an 8 char array. */
> +               volatile char data[8];
>
> -               p[12] = 0x12345678;
> +               memset((void *)data, 0, 64);
>                 break;
>         }
>         case CT_UNALIGNED_LOAD_STORE_WRITE: {
> --
> 1.7.9.5
>



-- 
Kees Cook
Chrome OS Security
