Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab3GPAqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 20:46:48 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39721 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab3GPAqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 20:46:47 -0400
Subject: Re: CONFIG_* used by user-space to figure out whether a feature is
 on/off
From: Raymond Jennings <shentino@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <CA+55aFxShsoiTfXUJM2463ZHPNzBsV_VcKBkM4NyGMpk6Cm=iQ@mail.gmail.com>
References: <20130715154050.GA5941@phenom.dumpdata.com>
	 <CA+55aFxShsoiTfXUJM2463ZHPNzBsV_VcKBkM4NyGMpk6Cm=iQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Jul 2013 17:46:43 -0700
Message-ID: <1373935603.31535.3.camel@warfang>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 10:17 -0700, Linus Torvalds wrote:
> On Mon, Jul 15, 2013 at 8:40 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >
> > I am hoping you can help me draw an understanding and a line in sand whether:
> >  a) Tools should not depend on /proc/config.gz to figure out whether
> >     a kernel has some CONFIG_X=y feature.
> 
> Well, /proc/config.gz is better than some crazy saved-off config file,
> since it at least is guaranteed to match the kernel you're running,
> but it's still a completely crazy idea. Not the least because it's not
> at all guaranteed to be there, and even if it's there, we'll rename
> config options without caring one whit. It's meant for "make
> oldconfig" style stuff, nothing more. Any user program that depends on
> it is broken by design.
> 
> >  b) If they are OK to do so, what do we do when certain CONFIG_X options
> >     get reworked/removed. Would they be considered regressions? Aka
> >     is this similar to 'you shall not break user-space'?
> 
> Absolutely not. If you depend on any config file, you're broken by
> definition. The only thing that can depend on the config file is the
> kernel tree itself, and even then we happily break that at any time
> (ie "make oldconfig" is meant to give an _approximation_ of the old
> config, but if some config option gets renamed, the old value is
> thrown away without question, and the new name is asked about).
> 
> > Irrespective of that, do you have any ideas of how a user-space program (say GRUB)
> > can figure out whether the configuration stanze it generates is supported by
> > the kernel.

I'd like to point out that Google Chrome also makes use of CONFIG_ tests
to detect support for namespaces and pid containers and stuff.

> If you don't want to answer this question - since this might
> > open a can of worms you prefer not to deal with - that is absolutly OK.
> 
> I think grub should stop trying to be clever. Quite frankly, from my
> own experience, grub has become too clever by half, and become harder
> to use and configure as a result. Just don't do it.
> 
> If you want to have grub Xen options for the kernel, make them grub
> options. In the grub config file. And if that option isn't there, just
> boot it as a native kernel. That had better work anyway, and is a hell
> of a lot more flexible and stable anyway. Don't try to be clever, and
> certainly don't try to parse some random config file that may or may
> not even match the kernel you're booting.
> 
>                  Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


