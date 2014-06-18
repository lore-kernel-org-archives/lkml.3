Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbaFRUIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:08:16 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:59322 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaFRUIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:08:15 -0400
MIME-Version: 1.0
In-Reply-To: <3604441.fZpjWNppGq@sifl>
References: <1402502130-26400-1-git-send-email-gidisrael@gmail.com>
	<1402502130-26400-2-git-send-email-gidisrael@gmail.com>
	<3604441.fZpjWNppGq@sifl>
Date: Wed, 18 Jun 2014 22:08:13 +0200
X-Google-Sender-Auth: liMP0JvkImukgbhl5OzSNLPhYO0
Message-ID: <CAMuHMdVJ7zv0qqhZNMNXihm4Kqv9WA9yyMe3F9ptUZyDjvEnTg@mail.gmail.com>
Subject: Re: [PATCH 1/1] security: Used macros from compiler.h instead of __attribute__((...))
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Gideon Israel Dsouza <gidisrael@gmail.com>, sds@tycho.nsa.gov,
        Eric Paris <eparis@parisplace.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 8:50 PM, Paul Moore <paul@paul-moore.com> wrote:
> On Wednesday, June 11, 2014 09:25:30 PM Gideon Israel Dsouza wrote:
>> To increase compiler portability there is <linux/compiler.h> which
>> provides convenience macros for various gcc constructs.  Eg: __packed
>> for __attribute__((packed)).
>>
>> This patch is part of a large task I've taken to clean the gcc
>> specific attributes and use the the macros instead.
>>
>> Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
>> ---
>>  security/selinux/include/security.h | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> From what I can tell this should still work with both the LLVM and Intel
> compilers, is that correct?

That's the idea of the compiler-agnostic attribute macros.

Interestingly, only include/linux/compiler-gcc.h defines __packed.

As it's already in heavy use, I can only assume both LLVM and the Intel
compilers handle both "__packed" (without a special definition) and the
gcc-specific "__attribute__((packed))".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
