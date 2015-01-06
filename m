Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbbAFThJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:37:09 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:54666 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbbAFThG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:37:06 -0500
MIME-Version: 1.0
In-Reply-To: <54AC3395.9080101@hurleysoftware.com>
References: <1420536979-31149-1-git-send-email-geert@linux-m68k.org>
	<54AC3395.9080101@hurleysoftware.com>
Date: Tue, 6 Jan 2015 20:37:04 +0100
X-Google-Sender-Auth: y83elA38hi45zUhblrPikSrynaM
Message-ID: <CAMuHMdX=RXoSiPHinoyyXdiLFPPLU2bs4qWkyxGzHuCYmgwxiA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.19-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Jan 6, 2015 at 8:12 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>>   + /home/kisskb/slave/src/drivers/tty/serial/8250/8250_core.c: warning: 'flags' may be used uninitialized in this function:  => 3186:16
>
> Is there some way of finding out what gcc + config produced this warning?

I have it in my summary, but I first have to learn kup before I can publish it.

It's from or32/or1ksim_defconfig, with or32-linux-gcc 4.5.1-or32-1.0rc1.
That's the only remaining 4.5 compiler used by kisskb, I think.

Note that I also see it with m68k-linux-gnu-gcc version 4.1.2 20061115
(prerelease) (Ubuntu 4.1.1-21), which is still my main kernel compiler for m68k.

> I know what commit produced this build regression but I'm not seeing a problem

(old) gcc is not smart enough to notice that flags is used only if locked = 1.
(new) gcc is probably also not smart enough, but someone disabled those
warnings because there were too many false positives...

Anyway, I always investigate new warnings that show up in my m68k builds
(incl. allyesconfig and allmodconfig, plain and limited to Sun-3). So I already
knew this is a false positive ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
