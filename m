Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3GORRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:17:05 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:54262 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3GORRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:17:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130715154050.GA5941@phenom.dumpdata.com>
References: <20130715154050.GA5941@phenom.dumpdata.com>
Date: Mon, 15 Jul 2013 10:17:01 -0700
X-Google-Sender-Auth: fKxjPfzKw2ipEcz5uZE3cuepMCE
Message-ID: <CA+55aFxShsoiTfXUJM2463ZHPNzBsV_VcKBkM4NyGMpk6Cm=iQ@mail.gmail.com>
Subject: Re: CONFIG_* used by user-space to figure out whether a feature is on/off
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 8:40 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
> I am hoping you can help me draw an understanding and a line in sand whether:
>  a) Tools should not depend on /proc/config.gz to figure out whether
>     a kernel has some CONFIG_X=y feature.

Well, /proc/config.gz is better than some crazy saved-off config file,
since it at least is guaranteed to match the kernel you're running,
but it's still a completely crazy idea. Not the least because it's not
at all guaranteed to be there, and even if it's there, we'll rename
config options without caring one whit. It's meant for "make
oldconfig" style stuff, nothing more. Any user program that depends on
it is broken by design.

>  b) If they are OK to do so, what do we do when certain CONFIG_X options
>     get reworked/removed. Would they be considered regressions? Aka
>     is this similar to 'you shall not break user-space'?

Absolutely not. If you depend on any config file, you're broken by
definition. The only thing that can depend on the config file is the
kernel tree itself, and even then we happily break that at any time
(ie "make oldconfig" is meant to give an _approximation_ of the old
config, but if some config option gets renamed, the old value is
thrown away without question, and the new name is asked about).

> Irrespective of that, do you have any ideas of how a user-space program (say GRUB)
> can figure out whether the configuration stanze it generates is supported by
> the kernel. If you don't want to answer this question - since this might
> open a can of worms you prefer not to deal with - that is absolutly OK.

I think grub should stop trying to be clever. Quite frankly, from my
own experience, grub has become too clever by half, and become harder
to use and configure as a result. Just don't do it.

If you want to have grub Xen options for the kernel, make them grub
options. In the grub config file. And if that option isn't there, just
boot it as a native kernel. That had better work anyway, and is a hell
of a lot more flexible and stable anyway. Don't try to be clever, and
certainly don't try to parse some random config file that may or may
not even match the kernel you're booting.

                 Linus
