Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaBCWrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:47:17 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:33436 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaBCWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:47:16 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
References: <1391452183-2160-1-git-send-email-bp@alien8.de>
	<alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
Date: Mon, 3 Feb 2014 14:47:15 -0800
X-Google-Sender-Auth: A4vnsRqVOg9LRyoiUKQSjHNBjto
Message-ID: <CA+55aFzwB0-fcqa_RaNDE1jjS+awM=j3BGroA5C3wRnK_G7UHg@mail.gmail.com>
Subject: Re: [PATCH] Clarify CONFIG_DEBUG_INFO's bloaty nature
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Richard Weinberger <richard@nod.at>,
        Borislav Petkov <bp@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 2:00 PM, David Rientjes <rientjes@google.com> wrote:
>
> How do you define "huge bloat" if the size of vmlinux doesn't increase?

Don't be silly. The size of all the object files increase *hugely*.

This is my fs/builtin.o in my normal config:

  -rw-rw-r--. 1 torvalds torvalds  2838613 Feb  3 14:32 fs/built-in.o

and with the *reduced* debug info, ie .config diff as follows:

  +CONFIG_DEBUG_INFO=y
  +CONFIG_DEBUG_INFO_REDUCED=y

I get this:

  -rw-rw-r--. 1 torvalds torvalds 11793317 Feb  3 14:33 fs/built-in.o

iow, that "reduced" debug info is still more than 4x bigger than a
non-debug-info kernel.

David, if you don't think that debug-info bloats the build, you're in
huge *huge* denial. CONFIG_DEBUG_INFO (even with the "reduced" thing)
is ABSOLUTELY HORRIBLE CRAP.

> Would some people consider that to be acceptable but now mysteriously
> confused because we don't know what "huge bloat" you're referring to?

That >4x size increase doesn't match your idea of "huge bloat"?

The object files being much bigger really does screw you especially on
laptops that often have less memory and less capable IO subsystems.
The final links in particular tend to be much bigger and use much more
memory.

I suspect a lot of people are in denial about just how *horrible* the
overhead of debug builds are. And yeah, if you have oodles of memory
to cache things, it's not too bad. But you really want to have *lots*
of memory, because otherwise you won't be caching all those object
files in RAM, and your build easily becomes IO bound at link time. A
factor of four size difference will not be helping your poor slow
laptop disk..

                      Linus
