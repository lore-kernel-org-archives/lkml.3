Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab3JPOzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:55:18 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:65366 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3JPOzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:55:16 -0400
MIME-Version: 1.0
In-Reply-To: <525E3786.7030102@zytor.com>
References: <20131016064314.GA2739@www.outflux.net>
	<525E3786.7030102@zytor.com>
Date: Wed, 16 Oct 2013 07:55:15 -0700
X-Google-Sender-Auth: 0QUzuanpHCeN0EgKDmaivogWC1k
Message-ID: <CAGXu5j+EUA_5E=-r+hhGYarMvt2PWp8Eu==6EP9ZKp9c5VjtYg@mail.gmail.com>
Subject: Re: [PATCH] x86, relocs: add percpu fixup for GNU ld 2.23
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Michael Davidson <md@google.com>,
        Cong Ding <dinggnu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 11:51 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/15/2013 11:43 PM, Kees Cook wrote:
>> The GNU linker tries to put __per_cpu_load into the percpu area, resulting
>> in a lack of its relocation. Force this symbol to be relocated. Seen
>> starting with GNU ld 2.23 and later.
>>
>> Reported-by: Ingo Molnar <mingo@kernel.org>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/x86/tools/relocs.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
>> index 1fa291f..7a85f29 100644
>> --- a/arch/x86/tools/relocs.c
>> +++ b/arch/x86/tools/relocs.c
>> @@ -729,6 +729,7 @@ static void percpu_init(void)
>>   *
>>   * The GNU linker incorrectly associates:
>>   *   __init_begin
>> + *   __per_cpu_load
>>   *
>>   * The "gold" linker incorrectly associates:
>>   *   init_per_cpu__irq_stack_union
>> @@ -738,6 +739,7 @@ static int is_percpu_sym(ElfW(Sym) *sym, const char *symname)
>>  {
>>       return (sym->st_shndx == per_cpu_shndx) &&
>>               strcmp(symname, "__init_begin") &&
>> +             strcmp(symname, "__per_cpu_load") &&
>>               strncmp(symname, "init_per_cpu_", 13);
>>  }
>>
>>
>
> Why isn't this list using a regex like other symbol classes?

I assume because it was initially a single item and it has grown
slowly. Would you like me to convert it to a regex instead?

-Kees

-- 
Kees Cook
Chrome OS Security
