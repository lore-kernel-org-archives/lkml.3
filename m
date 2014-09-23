Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbaIWISM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:18:12 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:37588 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbaIWISJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20140919104021.GA11552@gmail.com>
	<CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
	<20140923053510.GB27825@gmail.com>
	<20140923053711.GA28704@gmail.com>
	<20140923055802.GA29052@gmail.com>
	<1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
Date: Tue, 23 Sep 2014 10:18:07 +0200
Message-ID: <CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Roy Franz <roy.franz@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 September 2014 09:20, Matt Fleming <matt.fleming@intel.com> wrote:
> On Tue, 2014-09-23 at 07:58 +0200, Ingo Molnar wrote:
>>
>> So if it's the GOT fixup then I feel the safest option is to
>> revert 9cb0e394234d straight away, and then to do a functional
>> revert of f23cf8bd5c1f49 as a separate step, perhaps via
>> something really crude like:
>>
>>    #include "../..../drivers/firmware/efi/libstub/efi-stub-helper.c"
>>
>> or so. (Maybe someone else can think of something
>> cleaner/simpler, because this method is really ugly, as we'd have
>> to #include the whole libstub library into eboot.c AFAICS...)
>
> Yeah, I think at this point in the release cycle it would be safest to
> revert back to the original scheme of #including the .c files. I'm not

Agreed

> sure if we can do any better in a robust way, i.e. without introducing
> more regressions. Then take a look at doing the boot stub unification
> with fresh eyes (and improved testing) after v3.17.
>
> What I want to avoid is reverting the arm64 side of things too, so I'm
> gonna take a stab at doing the necessary reverts/partial
> reverts/whatever to get x86 back to the pre-merge window boot stub
> duplicated code scheme.
>

The stub unification was already working fine in 3.16, it is the
libstub cleanup I did that is causing this, so we could revert just
all of that if it makes it easier to get this fixed for the release.

Unless your last patch was incorrect (which I don't think it was), the
only way to solve this conclusively is finding a way (i.e., through
visibility=hidden attributes for efi_early etc) to share those symbols
between .o files without introducing any new GOT entries. Anyone in
team x86 that can shed some light on why hidden globals still generate
GOT entries on 32 bit?

It will be difficult for me to keep up with this thread over the next
days, so I have added Leif and Roy on cc. If you need to make any
changes that affect arm64, they should be able to confirm whether it
causes any problems or not.

Thanks,
Ard.
