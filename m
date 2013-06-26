Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab3FZHeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:34:44 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64025 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3FZHem convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:34:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130625193951.GF15184@roeck-us.net>
References: <20130625183915.443950649@linuxfoundation.org>
	<20130625192300.GA10427@roeck-us.net>
	<CAMuHMdVzqOLTVWHeGEFpkpDTt8hpor9zQpnn4bPDaNEGWnb=SQ@mail.gmail.com>
	<20130625193951.GF15184@roeck-us.net>
Date: Wed, 26 Jun 2013 09:34:42 +0200
X-Google-Sender-Auth: 2TyaIIg9KadVk-p-5kVVI_MCwv8
Message-ID: <CAMuHMdWK9xorBaTH+Zg9z1XU=JMsSffzGEfv5KHXnMZLX04PCw@mail.gmail.com>
Subject: Re: [ 00/17] 3.0.84-stable review
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 9:39 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Tue, Jun 25, 2013 at 09:32:26PM +0200, Geert Uytterhoeven wrote:
>> Hi Günther,
>>
>> On Tue, Jun 25, 2013 at 9:23 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> > Build m68k:defconfig passed
>> > Build m68k:apollo_defconfig passed
>> > Build m68k:m5272c3_defconfig failed
>> > Build m68k:m5307c3_defconfig failed
>> > Build m68k:m5249evb_defconfig failed
>> > Build m68k:m5407c3_defconfig failed
>> > Build m68k:mac_defconfig passed
>> > Build m68k:multi_defconfig passed
>> > Build m68k:sun3_defconfig passed
>> > Build m68k:sun3x_defconfig passed
>> > Build m68k:mvme16x_defconfig passed
>> > Build m68k:hp300_defconfig passed
>>
>> m68k:defconfig is an alias for m68k:multi_defconfig, so you can drop
>> one of them.
>>
>> Furthermore, m68k:multi_defconfig is the union of all m68k "classic MMU"
>> defconfigs, except for sun3_defconfig (due to the incompatible MMU type).
>> Hence dropping apollo_defconfig, mac_defconfig, sun3x_defconfig,
>> mvme16x_defconfig, and hp300_defconfig would reduce your build coverage
>> only marginally. Of course, if you have too many spare cycles ;-)
>>
> Thanks, I'll do that. The complete build for three releases takes 15+ hours
> with i7-3700k, so reducing that a bit doesn't hurt.

FYI, you still built m68k:mvme16x_defconfig for v3.9.7-95-g6a2f14b.

> Would there be any useful builds to add ?

You could add m68k:m5475evb_defconfig, which is the only Coldfire
defconfig with MMU=y.

Greg: Any other advice for Coldfire?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
