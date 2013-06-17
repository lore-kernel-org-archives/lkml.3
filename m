Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab3FQKLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:11:44 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:64638 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385Ab3FQKLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:11:42 -0400
MIME-Version: 1.0
In-Reply-To: <27908.1371460079@warthog.procyon.org.uk>
References: <1371413189-2568-1-git-send-email-ddaney.cavm@gmail.com>
	<1371413189-2568-3-git-send-email-ddaney.cavm@gmail.com>
	<27908.1371460079@warthog.procyon.org.uk>
Date: Mon, 17 Jun 2013 12:11:41 +0200
X-Google-Sender-Auth: AKx-sWgAy-YJE2T4AZUs04jL0iY
Message-ID: <CAMuHMdU9dX61FrZBicFSaS6CKqox2OJ2iXJk6nq9VUf+ThkKLg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mn10300: Fix include dependency in irqflags.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, david.s.daney@gmail.com,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 11:07 AM, David Howells <dhowells@redhat.com> wrote:
> ddaney.cavm@gmail.com wrote:
>
>>  #ifndef __ASSEMBLY__
>> -#include <linux/smp.h>
>> +/* linux/smp.h <- linux/irqflags.h needs asm/smp.h first */
>> +#include <asm/smp.h>
>>  #endif
>
> If you make this change, is the #ifndef __ASSEMBLY__ still necessary, I
> wonder...

Seems to be fine, for asb2303_defconfig.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
