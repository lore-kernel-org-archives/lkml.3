Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab3IJQve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 12:51:34 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35775 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3IJQvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 12:51:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130910164404.GA1690@roeck-us.net>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
	<20130909015945.GA4029@kroah.com>
	<20130909134012.GA24738@infradead.org>
	<20130909163902.GA28685@kroah.com>
	<20130909170819.GA22764@roeck-us.net>
	<20130909172232.GA10029@kroah.com>
	<CAMuHMdWwFwWeenfsiF+yBYS29rwJTJ1YP5waf=ePK+MRCru3qg@mail.gmail.com>
	<20130909200610.GA28416@roeck-us.net>
	<CAMuHMdXWaVivv3RL9dyLdeA7p4=XiBLAyhXNEiay3ARoWjM5gw@mail.gmail.com>
	<20130910164404.GA1690@roeck-us.net>
Date: Tue, 10 Sep 2013 18:51:32 +0200
X-Google-Sender-Auth: AHtg6Nk3TGpNtsIzCUYGJeOnWZs
Message-ID: <CAMuHMdV=3F2meFAgTY2ndyqOexh91cqKb4BW53us4A7ncYLWhQ@mail.gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and XTENSA
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>, Peng Tao <tao.peng@emc.com>,
        Peng Tao <bergwolf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 6:44 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> I tried with 2.6.3 from crosstool, and it succeeded, too.
>>
> Do such old versions of gcc still exist ? Just kidding :)
>
>> Turns out cfs_access_process_vm() is called with write=0 only.
>> Gcc 2.6.3 optimizes away the write != 0 branch (which calls copy_to_user_page()
>> and thus flush_icache_user_range()), while gcc 4.1.2 doesn't do that.
>> Mystery solved.
>>
> Still bad. Guess it would still fail with 4.6.3 if optimization is turned off.

For the record: s/2.6.3/4.6.3/.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
