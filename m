Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaEVHsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:48:04 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:51975 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaEVHsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:48:01 -0400
MIME-Version: 1.0
In-Reply-To: <537DA7F5.6010704@southpole.se>
References: <1400530303-29182-1-git-send-email-stefan.kristiansson@saunalahti.fi>
	<alpine.DEB.2.02.1405200809260.5204@ionos.tec.linutronix.de>
	<20140521195056.GA14701@chokladfabriken.org>
	<537DA7F5.6010704@southpole.se>
Date: Thu, 22 May 2014 09:48:00 +0200
X-Google-Sender-Auth: AQNYlBABdgGbL4wtDKZP5g8Dfss
Message-ID: <CAMuHMdX6s1yYpwVoRiQYr2F5MTKqgSFLzVRniw6QYHgUmG7KBA@mail.gmail.com>
Subject: Re: [ORLinux] [PATCH v2] openrisc: irq: use irqchip framework
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, linux <linux@openrisc.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 9:32 AM, Jonas Bonn <jonas@southpole.se> wrote:
> On 05/21/2014 09:50 PM, Stefan Kristiansson wrote:
>> I see two paths to go to get there though, and here's where I'd like some input.
>> 1) Define the three different implementations as seperate irqchips,
>>    with accompanying IRQCHIP_DECLARE.
>> 2) Add custom device-tree bindings and determine the chip type from that.
>
> I think 1) above is the way to go.  Something alone the lines of
> "opencores,or1k-pic-level", "opencores,or1k-pic-edge", and
> "opencores,or1200-pic".

Sounds fine to me. The only thing I'm still wondering about is whether
to have both "opencores,or1k-pic-*" variants, or just ""opencores,or1k-pic"
and an (optional) property for edge/level selection.

Is edge support planned to stay in future versions of the specifications?
If not, go with the optional property to select edge.
If yes, have two variants.

> The first two match the behaviour of the or1k specification; the third
> one, however, is really a misimplementation of the spec and is kind of
> tied to the actual implementation of the OR1200... I wonder if we don't
> need to version this one like we version the CPU identifier (*-rtlsvnXXXXX).

Is this planned to be fixed for OR1200?
If yes, how? If this will be done by switching to the version that follows the
or1k spec, the compatible value in DT can just be changed to one of the
"opencores,or1k-pic-*" variants.

Just my 2 c...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
