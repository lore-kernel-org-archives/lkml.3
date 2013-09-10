Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab3IJRQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:16:12 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33665 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3IJRQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:16:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXWaVivv3RL9dyLdeA7p4=XiBLAyhXNEiay3ARoWjM5gw@mail.gmail.com>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com> <20130909134012.GA24738@infradead.org>
 <20130909163902.GA28685@kroah.com> <20130909170819.GA22764@roeck-us.net>
 <20130909172232.GA10029@kroah.com> <CAMuHMdWwFwWeenfsiF+yBYS29rwJTJ1YP5waf=ePK+MRCru3qg@mail.gmail.com>
 <20130909200610.GA28416@roeck-us.net> <CAMuHMdXWaVivv3RL9dyLdeA7p4=XiBLAyhXNEiay3ARoWjM5gw@mail.gmail.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 11 Sep 2013 01:15:49 +0800
Message-ID: <CA+a=Yy4qtts8YRoF73AxfB2NpeFVw3hCZtVkRiKaw7XS8SDAfg@mail.gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and XTENSA
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 4:49 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Mon, Sep 9, 2013 at 10:06 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>> [*] Why does m68k allmodconfig still succeed on kissb???
>>>     It does fail for me, as m68k's copy_from_user_page() calls
>>>     flush_icache_user_range(), which is not exported.
>>>
>> I don't see a build failure in m68k:allmodconfig either.
>>
>> flush_icache_user_range() is called from copy_to_user_page(), not from
>> copy_from_user_page(). copy_from_user_page() calls flush_cache_page()
>> which calls __flush_cache_030(). The first is inline, the second is
>> assembler, so I would expect it to work. Which doesn't answer
>> the question why it fails for you.
>
> Sorry, I meant copy_to_user_page().
>
> I tried with 2.6.3 from crosstool, and it succeeded, too.
>
> Turns out cfs_access_process_vm() is called with write=0 only.
> Gcc 2.6.3 optimizes away the write != 0 branch (which calls copy_to_user_page()
> and thus flush_icache_user_range()), while gcc 4.1.2 doesn't do that.
> Mystery solved.
>
Thanks for chasing down the root cause. I was also wondering why I
didn't see this when building on MIPS some time ago.

Thanks,
Tao

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
