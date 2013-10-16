Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3JPGw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 02:52:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54245 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3JPGw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:52:56 -0400
Message-ID: <525E3786.7030102@zytor.com>
Date: Tue, 15 Oct 2013 23:51:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Michael Davidson <md@google.com>,
        Cong Ding <dinggnu@gmail.com>
Subject: Re: [PATCH] x86, relocs: add percpu fixup for GNU ld 2.23
References: <20131016064314.GA2739@www.outflux.net>
In-Reply-To: <20131016064314.GA2739@www.outflux.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 11:43 PM, Kees Cook wrote:
> The GNU linker tries to put __per_cpu_load into the percpu area, resulting
> in a lack of its relocation. Force this symbol to be relocated. Seen
> starting with GNU ld 2.23 and later.
> 
> Reported-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/tools/relocs.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
> index 1fa291f..7a85f29 100644
> --- a/arch/x86/tools/relocs.c
> +++ b/arch/x86/tools/relocs.c
> @@ -729,6 +729,7 @@ static void percpu_init(void)
>   *
>   * The GNU linker incorrectly associates:
>   *	__init_begin
> + *	__per_cpu_load
>   *
>   * The "gold" linker incorrectly associates:
>   *	init_per_cpu__irq_stack_union
> @@ -738,6 +739,7 @@ static int is_percpu_sym(ElfW(Sym) *sym, const char *symname)
>  {
>  	return (sym->st_shndx == per_cpu_shndx) &&
>  		strcmp(symname, "__init_begin") &&
> +		strcmp(symname, "__per_cpu_load") &&
>  		strncmp(symname, "init_per_cpu_", 13);
>  }
>  
> 

Why isn't this list using a regex like other symbol classes?

	-hpa

