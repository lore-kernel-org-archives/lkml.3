Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaBUU35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:29:57 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34342 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaBUU3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:29:55 -0500
MIME-Version: 1.0
In-Reply-To: <20140209215644.GA30339@www.outflux.net>
References: <20140209215644.GA30339@www.outflux.net>
Date: Fri, 21 Feb 2014 12:29:55 -0800
X-Google-Sender-Auth: G7_klXGa4-I7sHvyGumZWuhkcGo
Message-ID: <CAGXu5jLT=KELXVXYHRyG1GBTCzcxfm5fMdqg5pis93JXQ9GXRw@mail.gmail.com>
Subject: Re: [PATCH] x86, kaslr: add missed "static" declarations
From: Kees Cook <keescook@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 9, 2014 at 1:56 PM, Kees Cook <keescook@chromium.org> wrote:
> This silences build warnings about unexported variables and functions.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/boot/compressed/aslr.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
> index 90a21f430117..4dbf967da50d 100644
> --- a/arch/x86/boot/compressed/aslr.c
> +++ b/arch/x86/boot/compressed/aslr.c
> @@ -111,7 +111,7 @@ struct mem_vector {
>  };
>
>  #define MEM_AVOID_MAX 5
> -struct mem_vector mem_avoid[MEM_AVOID_MAX];
> +static struct mem_vector mem_avoid[MEM_AVOID_MAX];
>
>  static bool mem_contains(struct mem_vector *region, struct mem_vector *item)
>  {
> @@ -180,7 +180,7 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
>  }
>
>  /* Does this memory vector overlap a known avoided area? */
> -bool mem_avoid_overlap(struct mem_vector *img)
> +static bool mem_avoid_overlap(struct mem_vector *img)
>  {
>         int i;
>
> @@ -192,8 +192,9 @@ bool mem_avoid_overlap(struct mem_vector *img)
>         return false;
>  }
>
> -unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET / CONFIG_PHYSICAL_ALIGN];
> -unsigned long slot_max = 0;
> +static unsigned long slots[CONFIG_RANDOMIZE_BASE_MAX_OFFSET /
> +                          CONFIG_PHYSICAL_ALIGN];
> +static unsigned long slot_max;
>
>  static void slots_append(unsigned long addr)
>  {
> --
> 1.7.9.5
>
>
> --
> Kees Cook
> Chrome OS Security

Ping on this patch; simple build warning fixes...

-Kees

-- 
Kees Cook
Chrome OS Security
