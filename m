Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab3GPHoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 03:44:00 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35044 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3GPHn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 03:43:57 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxGymOvvaYfOg22AdHpxEOuOctfC8vRW+_u=vtua8Dksg@mail.gmail.com>
References: <1373876954-30437-1-git-send-email-geert@linux-m68k.org>
	<CA+55aFxGymOvvaYfOg22AdHpxEOuOctfC8vRW+_u=vtua8Dksg@mail.gmail.com>
Date: Tue, 16 Jul 2013 09:43:56 +0200
X-Google-Sender-Auth: y64dJKJvoltoLxEO4igCq942LKQ
Message-ID: <CAMuHMdV9vgh89oRsMsH25Jx-nEJh1e6NV02i5EXKhM9bQsCkrA@mail.gmail.com>
Subject: Re: [PATCH] logo: Remove trailing whitespace from logo_linux_clut224.ppm
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Jul 16, 2013 at 3:02 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jul 15, 2013 at 1:29 AM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> Commit ad81f0545ef01ea651886dddac4bef6cec930092 ("Linux 3.11-rc1")
>> replaced the Standard 224-color Linux logo, and introduced lots of
>> trailing whitespace. Remove it again.
>
> The logo is temporary, and I'd rather keep it the way it is so that a
> simple revert will fix things up again..

OK, that's a good reason. But unlike last time with Tuz, you can't revert
the whole commit, as that also reverts the version ;-)

> That said, even if it wasn't temporary, I think we might be better off
> with the raw format that the netpbm tools generate these days. It was
> actually slightly annoying to get that big diff from a small edit, and
> it was the result of either the original logo ASCII representation
> having been cleaned up excessively before, or possibly just the netpbm
> tools having changed their output radically.

It seems there are different versions. My (Ubuntu 12.04 LTS) version of
pnmnoraw doesn't add trailing whitespace, but groups the values per
pixel. The old version used to generate the pre-v3.11-rc1 logo didn't
group the values, but used he same width for all fields.

> Of course, it would be even better if we actually used some saner
> format. I'm not exactly artistic, so making that whole silly logo
> change took more time than it really should have. But what was
> *really* painful was to fight the horrible ppm format conversion
> issues, and how we only accept that legacy ascii version etc.

When the logo conversion code was written (before we just had C header
files with arrays, which were a hell to update), my requirements were:
  1. The format must be easy to generate with commonly used tools,
  2. The format must be ASCII, to allow emailing of patches,
  3. The format must be easily parsable, without relying on external tools and
     libraries.

Thanks to "GIT binary patch", 2 is no longer required.
If we switch to e.g. PNG, we may have to rely on one more external library,
upsetting Rob.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
