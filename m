Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3IFPTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:19:10 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41140 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3IFPTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:19:08 -0400
MIME-Version: 1.0
In-Reply-To: <5229F10A.7000503@lwfinger.net>
References: <5229F10A.7000503@lwfinger.net>
Date: Fri, 6 Sep 2013 17:19:07 +0200
X-Google-Sender-Auth: fRsxaIbSZkMlCjbnjxXZGD0QmYo
Message-ID: <CAMuHMdXX9YXbOtQ7_HXA0dVzHS4up5H4uUaOt=51uOD+dgcQQA@mail.gmail.com>
Subject: Re: Build warnings in b43 and b43legacy
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 5:13 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In http://lkml.indiana.edu/hypermail/linux/kernel/1309.0/00918.html and
> earlier postings of the build regressions in 3.11-rcX, I notice the
> following entries:
>
> + /scratch/kisskb/src/drivers/net/wireless/b43/b43.h: warning: 'packed'
> attribute ignored for field of type 'union <anonymous>' [-Wattributes]: =>
> 641:2
> + /scratch/kisskb/src/drivers/net/wireless/b43/xmit.h: warning: 'packed'
> attribute ignored for field of type 'struct <anonymous>' [-Wattributes]: =>
> 64:3, 88:3, 290:3, 283:3, 77:3
> + /scratch/kisskb/src/drivers/net/wireless/b43legacy/b43legacy.h: warning:
> 'packed' attribute ignored for field of type 'union <anonymous>'
> [-Wattributes]: => 381:2
>
> From the indicated source lines, and some research on the topic of packed
> attributes of anonymous entities, I think I know what it would take to fix
> these; however, I am reluctant to touch this code. Firstly, my compiler does
> not show the warning, and secondly, blindly reworking those critical
> structures could cause severe regressions.
>
> What compiler version and options does it take to get these warnings to
> appear?

All logs I analyze are from the linux-next build service at
http://kisskb.ellerman.id.au/kisskb/matrix/.

I think you can reproduce moft the warnings using the most recent toolchains at
https://www.kernel.org/pub/tools/crosstool/files/bin/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
