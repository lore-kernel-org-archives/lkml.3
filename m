Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaIALxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:53:18 -0400
Received: from mail-yh0-f54.google.com ([209.85.213.54]:57042 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbaIALxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:53:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVE4hf9Z1cAFFu_8Qdk2KVenHn+ygihq4PkQrKdDxNz2w@mail.gmail.com>
References: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1408957395-404-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<20140830225407.GF7996@ZenIV.linux.org.uk>
	<1409560606.30155.41.camel@linux.intel.com>
	<CAMuHMdUU8BVTtEb6QE7zW+XtF4yfbwg=O+Lv84A0F3X9M1t=Rw@mail.gmail.com>
	<1409562596.30155.43.camel@linux.intel.com>
	<CAMuHMdXUsK9Uwd8EVqiWW8rDsUe=h7U8bGntx=bfWYQ5j91x+A@mail.gmail.com>
	<CAHp75VeNegxwTB617mRXBomERjLbATASMM0tReUgZWprQEnXng@mail.gmail.com>
	<CAMuHMdWcWD2nMoRNooC=aMTMk07R9vmOfc1mzeNQJO8JATS8fA@mail.gmail.com>
	<1409571222.30155.55.camel@linux.intel.com>
	<CAMuHMdVE4hf9Z1cAFFu_8Qdk2KVenHn+ygihq4PkQrKdDxNz2w@mail.gmail.com>
Date: Mon, 1 Sep 2014 14:53:16 +0300
Message-ID: <CAHp75Vf2iOzOA9ZfP86+OodrpDxLHZX8SkxGO2MDU8qLe1S_uA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] seq_file: provide an analogue of print_hex_dump()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 1, 2014 at 2:49 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Hi Andy,
>
> On Mon, Sep 1, 2014 at 1:33 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>>> >> However, to protect against overflows if hex_dump_to_buffer() ever changes,
>>> >> I think it would be better to let hex_dump_to_buffer() indicate if the
>>> >> passed buffer was to small (it already checks the passed linebuflen).
>>> >> Then you can just check for that.
>>> >
>>> > I thought about that. We may introduce either new call and make
>>> > current one the user of it or change all occurrences.
>>> > Nevertheless, currently it will print only one groupsize if there is
>>> > enough room for it but for two or more.
>>> > Thus, I prefer to keep the behaviour "print until we can".
>>>
>>> The idea of seq_*() is that it will retry with a bigger bufsize if there's
>>> not enough space.
>>
>> Fair enough.
>>
>> So, summarize above, the check before hex_dump_to_buffer() should care
>> about maximum possible buffer needed for one line. But we have already
>> rowsize calculated (we actually can't rely on groupsize in this case).
>>
>> Do you agree with formula rowsize * 3 + 2 + rowsize + 1?
>
> That's the _current_ formula. The day hex_dump_to_buffer() is changed,
> it will break silently.

Do we have any other option except modify hex_dump_to_buffer() to
return an error when buffer is not enough?
In this case we require hex_dump_to_buffer() to follow this agreement
even if it's changed once.

-- 
With Best Regards,
Andy Shevchenko
