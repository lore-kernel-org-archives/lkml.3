Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3IJQoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:44:10 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41929 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3IJQoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:44:08 -0400
Date: Tue, 10 Sep 2013 09:44:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>, Peng Tao <tao.peng@emc.com>,
        Peng Tao <bergwolf@gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Message-ID: <20130910164404.GA1690@roeck-us.net>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com>
 <20130909134012.GA24738@infradead.org>
 <20130909163902.GA28685@kroah.com>
 <20130909170819.GA22764@roeck-us.net>
 <20130909172232.GA10029@kroah.com>
 <CAMuHMdWwFwWeenfsiF+yBYS29rwJTJ1YP5waf=ePK+MRCru3qg@mail.gmail.com>
 <20130909200610.GA28416@roeck-us.net>
 <CAMuHMdXWaVivv3RL9dyLdeA7p4=XiBLAyhXNEiay3ARoWjM5gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXWaVivv3RL9dyLdeA7p4=XiBLAyhXNEiay3ARoWjM5gw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 10:49:05AM +0200, Geert Uytterhoeven wrote:
> On Mon, Sep 9, 2013 at 10:06 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> >> [*] Why does m68k allmodconfig still succeed on kissb???
> >>     It does fail for me, as m68k's copy_from_user_page() calls
> >>     flush_icache_user_range(), which is not exported.
> >>
> > I don't see a build failure in m68k:allmodconfig either.
> >
> > flush_icache_user_range() is called from copy_to_user_page(), not from
> > copy_from_user_page(). copy_from_user_page() calls flush_cache_page()
> > which calls __flush_cache_030(). The first is inline, the second is
> > assembler, so I would expect it to work. Which doesn't answer
> > the question why it fails for you.
> 
> Sorry, I meant copy_to_user_page().
> 
> I tried with 2.6.3 from crosstool, and it succeeded, too.
> 
Do such old versions of gcc still exist ? Just kidding :)

> Turns out cfs_access_process_vm() is called with write=0 only.
> Gcc 2.6.3 optimizes away the write != 0 branch (which calls copy_to_user_page()
> and thus flush_icache_user_range()), while gcc 4.1.2 doesn't do that.
> Mystery solved.
> 
Still bad. Guess it would still fail with 4.6.3 if optimization is turned off.

Guenter

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
