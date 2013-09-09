Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3IITL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:11:27 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46012 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab3IITLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:11:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130909172232.GA10029@kroah.com>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
	<20130909015945.GA4029@kroah.com>
	<20130909134012.GA24738@infradead.org>
	<20130909163902.GA28685@kroah.com>
	<20130909170819.GA22764@roeck-us.net>
	<20130909172232.GA10029@kroah.com>
Date: Mon, 9 Sep 2013 21:11:25 +0200
X-Google-Sender-Auth: Omb9CP_7ZJ9AaAxFBjMrmHvpFVQ
Message-ID: <CAMuHMdWwFwWeenfsiF+yBYS29rwJTJ1YP5waf=ePK+MRCru3qg@mail.gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and XTENSA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: Guenter Roeck <linux@roeck-us.net>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>, Peng Tao <tao.peng@emc.com>,
        Peng Tao <bergwolf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 7:22 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Sep 09, 2013 at 10:08:19AM -0700, Guenter Roeck wrote:
>> On Mon, Sep 09, 2013 at 09:39:02AM -0700, Greg Kroah-Hartman wrote:
>> > On Mon, Sep 09, 2013 at 06:40:12AM -0700, Christoph Hellwig wrote:
>> > > On Sun, Sep 08, 2013 at 06:59:45PM -0700, Greg Kroah-Hartman wrote:
>> > > > Can't we just export the functions for those arches?  Surely lutre
>> > > > isn't the first/only driver that needs this?
>> > >
>> > > Lustre is.  These are core mm helpers, and lustre uses them to
>> > > reimplement another core VM function.  It then uses it to access
>> > > userspace environment variable.
>> > >
>> > > In short all this code should be nuked, and no new symbols should be
>> > > exported.
>> >
>> > Ugh, you are right, the lustre code needs to be fixed here.
>> >
>> Given that, should I send another patch marking it as BROKEN again ?
>
> Well, on those arches it's "broken", so I'll dig up your original patch
> on this thread.  It's just "normal" for staging drivers to duplicate
> core code, it needs to be fixed up before it can be merged into the
> kernel tree, so no need to do anything special.

It's not only broken on MIPS, SH, and XTENSA, but also on at least parisc
and m68k[*].

It's no longer broken on sparc64, as the missing export already got
into mainline.
In light of the above, perhaps that should be reverted?

[*] Why does m68k allmodconfig still succeed on kissb???
    It does fail for me, as m68k's copy_from_user_page() calls
    flush_icache_user_range(), which is not exported.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
