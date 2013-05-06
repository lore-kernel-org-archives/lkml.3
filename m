Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3EFOaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 10:30:10 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:42045 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3EFOaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 10:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXBk0oZUufY3KoFaZiawRHdm9juMqHPMTftqcjQDXnUgw@mail.gmail.com>
References: <CAMuHMdXBk0oZUufY3KoFaZiawRHdm9juMqHPMTftqcjQDXnUgw@mail.gmail.com>
Date: Mon, 6 May 2013 07:30:08 -0700
X-Google-Sender-Auth: de1Yl6kV7XMYbso9r37msofVJDk
Message-ID: <CA+55aFziLL++0XPHaZJiReoDUh+GQ0LTaaQFLBo4BEV7_fWrYA@mail.gmail.com>
Subject: Re: h8300 SYMBOL_NAME() breakage
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Al Viro <viro@zeniv.linux.org.uk>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 5:31 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> How should this be fixed?
>   - Re-add SYMBOL_NAME() to arch/h8300/include/asm/linkage.h?

No. The whole point was to *not* have these random private definitions.

I guess you could use VMLINUX_SYMBOL() and include <linux/export.h>
and then use VMLINUX_SYMBOL(). Although..

>   - Kill SYMBOL_NAME() and SYMBOL_NAME_LABEL(), and hardcode the
> underscores in the h8300 asm sources?

.. I think this is what everybody else does. Although sometimes that
underscore depends on what the linkage format is (ie historically
a.out vs elf etc). We pretty much expect ELF these days, but maybe
other conditional reasons exist - so there may be a reason you don't
want to do the hardcoding (although on h8300 it seems to be
unconditional at least for now).

                 Linus
