Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935264Ab3IDP62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:58:28 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:45664 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934941Ab3IDP60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:58:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130903143921.GA28290@gmail.com>
References: <20130903143921.GA28290@gmail.com>
Date: Wed, 4 Sep 2013 08:58:25 -0700
X-Google-Sender-Auth: dnz-a5i-YhvaOwkOZqb5zGe-K6Q
Message-ID: <CA+55aFxVv==DC0JdS87V+cPr-twN+TujYg5XmgHOjJOAkZ4xwQ@mail.gmail.com>
Subject: Re: [GIT PULL] x86/asmlinkage changes for v3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 3, 2013 at 7:39 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest x86-asmlinkage-for-linus git tree from:

Grr. This one seems to introduce this annoying warning:

arch/x86/kernel/paravirt.c:66:0: warning: "DEF_NATIVE" redefined
[enabled by default]
 #define DEF_NATIVE(ops, name, code)     \
 ^
In file included from
/home/torvalds/v2.6/linux/arch/x86/include/asm/ptrace.h:65:0,
                 from
/home/torvalds/v2.6/linux/arch/x86/include/asm/alternative.h:8,
                 from
/home/torvalds/v2.6/linux/arch/x86/include/asm/bitops.h:16,
                 from include/linux/bitops.h:22,
                 from include/linux/kernel.h:10,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:4,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from arch/x86/kernel/paravirt.c:22:
/home/torvalds/v2.6/linux/arch/x86/include/asm/paravirt_types.h:389:0:
note: this is the location of the previous definition
 #define DEF_NATIVE(ops, name, code)      \
 ^

when doing an allmodconfig.

Maybe it gets fixed later in the series (I am about a third through
your pull requests), but it's clearly bogus.

What the heck is wrong with that macro anyway? It is used in one
single file, and it is _defined_ twice - in two other files. Somebody
was very very confused when they wrote that code.

I'm going to let the pull stand, since it doesn't seem to actually
break anything, but this needs to be fixed.

                Linus
