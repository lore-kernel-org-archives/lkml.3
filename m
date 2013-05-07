Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab3EGMUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:20:52 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64962 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758444Ab3EGMUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWiQdUFREBMjQMmxrMa0LAOA2d3GqqeydyF5TK334ZwRw@mail.gmail.com>
References: <20130506160253.GA27181@linux-mips.org>
	<87mws8m3eu.fsf@hase.home>
	<20130507100447.GA15044@linux-mips.org>
	<CAMuHMdWiQdUFREBMjQMmxrMa0LAOA2d3GqqeydyF5TK334ZwRw@mail.gmail.com>
Date: Tue, 7 May 2013 14:20:50 +0200
X-Google-Sender-Auth: XIdk-TxU-m6d4PV6CVw80U9atVY
Message-ID: <CAMuHMdWRJrvWw35yC4AHcC7o-DrTLz9kT9ipQs9XP=55oSNNYQ@mail.gmail.com>
Subject: Re: Build errors caused by modalias generation patch
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 12:58 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, May 7, 2013 at 12:04 PM, Ralf Baechle <ralf@linux-mips.org> wrote:
>> On Mon, May 06, 2013 at 07:19:53PM +0200, Andreas Schwab wrote:
>>> Please try the patch in
>>> <http://marc.info/?l=linux-kbuild&m=136767800809256&w=2>.
>>
>> No change in observed behaviour.  I did all my builds in empty object
>> directories so I don't see why this patch would make any difference.
>
> I'm getting this in an ia64 build (don't ask me why I build for itanic ;-):
>
> FATAL: drivers/acpi/button: sizeof(struct acpi_device_id)=14 is not a
> modulo of the size of section __mod_acpi_device_table=144.
> Fix definition of struct acpi_device_id in mod_devicetable.h
>
> This is next-20130501, with or without Andreas' fix.
>
> It works in my development tree based on yesterday's mainline
> (d7ab7302f970a254997687a1cdede421a5635c68).
>
> I'll try today's linux-next, and will bisect if I find time...

This was also caused by a leftover scripts/mod/devicetable-offsets.h in the
source tree.

Andreas' fix works (sort of, read on), but only if you run "make mrproper"
_after_ applying it.

Still, if you have other leftovers from a previous build in the source tree,
you get:

  Using /scratch/geert/linux/linux-next as source for kernel
  /scratch/geert/linux/linux-next is not clean, please run 'make mrproper'
  in the '/scratch/geert/linux/linux-next' directory.

However, you don't get that message if there's still a stale
scripts/mod/devicetable-offsets.h in the source tree.
Any idea how to fix that?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
