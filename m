Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaAGJs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:48:58 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:57174 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaAGJsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:48:54 -0500
MIME-Version: 1.0
In-Reply-To: <20140107055532.GA16581@ravnborg.org>
References: <20140106204706.GA16924@leaf>
	<20140107055532.GA16581@ravnborg.org>
Date: Tue, 7 Jan 2014 10:48:53 +0100
X-Google-Sender-Auth: fhawt4uzMjSyll89JZeLdVRpt3E
Message-ID: <CAMuHMdWPq4YgUoxE1GvQbsEJQu-wjhpra2fRDgkNfEZP0sqpVQ@mail.gmail.com>
Subject: Re: #pragma once?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Marek <mmarek@suse.cz>,
        Rashika Kheria <rashika.kheria@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 6:55 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Mon, Jan 06, 2014 at 12:47:07PM -0800, Josh Triplett wrote:
>> [CCing build-system folks and others likely to know about potential
>> issues.]
>>
>> Does anyone have any objection to the use of "#pragma once" instead of
>> the usual #ifndef-#define-...-#endif include guard?  GCC, LLVM/clang,
>> and the latest Sparse all support either method just fine.  (I added
>> support to Sparse myself.)  Both have equivalent performance.  "#pragma
>> once" is simpler, and avoids the possibility of a typo in the defined
>> guard symbol.
> For kernel headers no concern.

Just being cautious:

Do we know the minimum gcc version that supports #pragma once?

Furthermore I found this:
| #pragma once does have one drawback (other than being non-standard) and
| that is if you have the same file in different locations then the
compiler will
| think these are different files.
http://stackoverflow.com/questions/787533/is-pragma-once-a-safe-include-guard

With asm-generic and uapi, do we have multiple header files that
deliberately use the same include guards?
I know we have header files that deliberately don't have include guards
(e.g. asm/unistd.h on some architectures).

> For UAPI headers we should be more carefull - as we do not know which
> compiler it ends up seeing - and what version.

Furthermore some userspace may rely on doing #define XXX to avoid
including a specific kernel header (yes, it's ugly).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
