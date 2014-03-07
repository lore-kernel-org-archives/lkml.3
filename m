Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaCGJ4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:56:35 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:56832 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaCGJ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:56:32 -0500
MIME-Version: 1.0
In-Reply-To: <1392724128-22920-1-git-send-email-jcmvbkbc@gmail.com>
References: <1392724128-22920-1-git-send-email-jcmvbkbc@gmail.com>
Date: Fri, 7 Mar 2014 13:56:31 +0400
Message-ID: <CAMo8BfJAOTHHmmiEpL7jZa4ySvyPYsHGYUY+myN68BeewjeWYg@mail.gmail.com>
Subject: Re: [PATCH] xtensa: enable sorting extable at build time
From: Max Filippov <jcmvbkbc@gmail.com>
To: David Daney <david.daney@cavium.com>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        LKML <linux-kernel@vger.kernel.org>, Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 3:48 PM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  arch/xtensa/Kconfig   | 1 +
>  scripts/sortextable.c | 5 +++++
>  2 files changed, 6 insertions(+)

Ping?
David, is this OK for scripts/sortextable.c?

> diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
> index 1ccaf91..381370d 100644
> --- a/arch/xtensa/Kconfig
> +++ b/arch/xtensa/Kconfig
> @@ -14,6 +14,7 @@ config XTENSA
>         select GENERIC_PCI_IOMAP
>         select ARCH_WANT_IPC_PARSE_VERSION
>         select ARCH_WANT_OPTIONAL_GPIOLIB
> +       select BUILDTIME_EXTABLE_SORT
>         select CLONE_BACKWARDS
>         select IRQ_DOMAIN
>         select HAVE_OPROFILE
> diff --git a/scripts/sortextable.c b/scripts/sortextable.c
> index cc49062..1052d48 100644
> --- a/scripts/sortextable.c
> +++ b/scripts/sortextable.c
> @@ -35,6 +35,10 @@
>  #define EM_ARCOMPACT   93
>  #endif
>
> +#ifndef EM_XTENSA
> +#define EM_XTENSA      94
> +#endif
> +
>  #ifndef EM_AARCH64
>  #define EM_AARCH64     183
>  #endif
> @@ -281,6 +285,7 @@ do_file(char const *const fname)
>         case EM_AARCH64:
>         case EM_MICROBLAZE:
>         case EM_MIPS:
> +       case EM_XTENSA:
>                 break;
>         }  /* end switch */
>
> --
> 1.8.1.4

-- 
Thanks.
-- Max
