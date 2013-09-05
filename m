Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3IESHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:07:21 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57521 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab3IESHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:07:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130905171338.GB25882@merlin.infradead.org>
References: <1378373595-29471-1-git-send-email-geert@linux-m68k.org>
	<1378396919.2142.5.camel@dabdike.int.hansenpartnership.com>
	<20130905171338.GB25882@merlin.infradead.org>
Date: Thu, 5 Sep 2013 20:07:19 +0200
X-Google-Sender-Auth: 2MQGFJSxtB5DAVPYOIi0x75TRYw
Message-ID: <CAMuHMdUmKFwpsN9c1qeGf7+=tqMkB=A1j2wSHBrsOYk+co5mog@mail.gmail.com>
Subject: Re: [PATCH] parisc: Export flush_cache_page() (needed by lustre)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kyle McMartin <kyle@infradead.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Parisc List <linux-parisc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 5, 2013 at 7:13 PM, Kyle McMartin <kyle@infradead.org> wrote:
> On Thu, Sep 05, 2013 at 09:01:59AM -0700, James Bottomley wrote:
>> > +EXPORT_SYMBOL_GPL(flush_cache_page);
>>
>> This is an internal API: no architecture exports this.  Whoever is
>> trying to use it needs to use the correct API, so this is the wrong
>> patch.
>>
>
> I suspect it's copy_{to,from}_user_page being called here:

Indeed. Sorry, I should have mentioned that.

> drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c:
> copy_to_user_page(vma, page, addr,
>
> which we could probably take out of line.

If you want to hide flush_cache_page() for modules, yes.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
