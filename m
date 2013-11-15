Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3KOKWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:22:32 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47277 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3KOKWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:22:23 -0500
MIME-Version: 1.0
In-Reply-To: <5285EE5A.1070202@southpole.se>
References: <1384029451-16555-1-git-send-email-geert@linux-m68k.org>
	<5285EE5A.1070202@southpole.se>
Date: Fri, 15 Nov 2013 11:22:22 +0100
X-Google-Sender-Auth: GivS5x12hRXo5Sg2OIiYohVtVaI
Message-ID: <CAMuHMdWA-9ax=NG_d0tyfzY3+42Ka7_r+jTeF-m5oW0eV8t1=g@mail.gmail.com>
Subject: Re: [PATCH] openrisc: Add DTS and defconfig for DE0-Nano
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux@openrisc.net,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Mehall <contact@kevinmehall.net>,
        Marek Czerski <ma.czerski@gmail.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonas,

On Fri, Nov 15, 2013 at 10:50 AM, Jonas Bonn <jonas@southpole.se> wrote:
>> +++ b/arch/openrisc/boot/dts/de0_nano.dts
>> @@ -0,0 +1,158 @@
>> +/dts-v1/;
>> +/ {
>> +       compatible = "opencores,de0_nano";
>
> This should probably be "altera,de0_nano".  We also need to put a version

"terasic,de0_nano"? The board says "Designed and manufactured by Terasic".
Hmm, the sticker on the box says "Altera DE0-Nano".

> number of some kind on this thing.  How are the de0_nano boards versioned?

That's a good question...

See also Andrew back's email and my response.

The supplied schematics filename is de0-nano-c4-rev-c\(release_cd_rom\).pdf,
and the drawings mention "Rev C".
The block diagram on page 2 still says "EPCS16 (16 Mb), but on page 8 it
mentions "EPCS64", which is what's on my board.

>> +       i2c0: ocores@a0000000 {
>> +               #address-cells = <1>;
>> +               #size-cells = <0>;
>> +               compatible = "opencores,i2c-ocores";
>
>
> Version number needed.  OpenCores wanted "projectname-rtlsvn###" where ###
> is the SVN commit number of the RTL directory in the project's source
> repository.

That's gonna need some information diving, as Stefan's orpsoc git repositories
only contains references to orpsocv2 git-svn-ids, not the svn ids of
the original
component repositories.

>> +       gpio0: gpio@91000000 {
>> +               compatible = "opencores,jbtrivial";
>
>
> There's no project called 'jbtrivial' at OpenCores.  Should this be
> "linux,jbtrivial" to indicate that this refers to a Linux driver?
>
>> +               reg = <0x91000000 0x2>;
>> +               #gpio-cells = <2>;
>> +               gpio-controller;
>> +               xlnx,data-offset = <0>;
>> +               xlnx,tri-offset = <1>;
>> +               xlnx,gpio-width = <8>;
>
>
> Yuck... I wrote this driver with a similar driver for a Xilinx part as a
> starting point.  Apparently I left the Xilenx (xlnx) tags in there for the
> device properties.  We can't really have it like this, though.
>
> Like I mentioned earlier, I'd like to see this thing disappear altogether
> and be replaced with gpio-generic.

That needs device-tree support and published bindings first. IIRC, you
had some preliminary code?

Thanks for review!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
