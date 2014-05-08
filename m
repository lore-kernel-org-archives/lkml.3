Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaEHNGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:06:04 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38038 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaEHNGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <536B7FD3.5090506@cogentembedded.com>
References: <1399494750-31996-1-git-send-email-geert+renesas@glider.be>
	<1399494750-31996-2-git-send-email-geert+renesas@glider.be>
	<536B7FD3.5090506@cogentembedded.com>
Date: Thu, 8 May 2014 15:06:01 +0200
X-Google-Sender-Auth: S_944s5mKbUYjSAlna6qmoUncWs
Message-ID: <CAMuHMdVoYnRcOVht0_Bt5_NJA3vZ40svftRXN-xbqHSMHZR5dg@mail.gmail.com>
Subject: Re: [PATCH 2/3] ARM: shmobile: r8a7740 dtsi: Add Ethernet support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Thu, May 8, 2014 at 3:00 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>> +       ether: ethernet@e9a00000 {
>
>    Are you really going to refer to this node somewhere, using its label?

Yes, from r8a7740-armadillo800eva-reference.dts

>> +               compatible = "renesas,gether-r8a7740";
>> +               reg = <0xe9a00000 0x800>,
>> +                     <0xe9a01800 0x800>;
>> +               interrupt-parent = <&gic>;
>> +               interrupts = <0 110 IRQ_TYPE_LEVEL_HIGH>;
>> +               /* clocks = <&mstp3_clks R8A7740_CLK_GETHER>; */
>
>    This property is mandatory, according to the bindings.

Indeed, but you cannot put anything there until the platform has CCF, as
mstp3_clks doesn't exist yet.
Currently it relies on a matching CLKDEV_DEV_ID() in platform code.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
