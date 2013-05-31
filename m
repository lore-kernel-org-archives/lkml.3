Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3EaJMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:12:36 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52992 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab3EaJM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:12:28 -0400
MIME-Version: 1.0
In-Reply-To: <51A70C10.6000408@asianux.com>
References: <51A6F0C6.9050806@asianux.com>
	<m2a9ndndu5.fsf@linux-m68k.org>
	<51A70C10.6000408@asianux.com>
Date: Fri, 31 May 2013 11:12:27 +0200
X-Google-Sender-Auth: Na1UjPRgHDP7uB4mdyIeCLsUEFE
Message-ID: <CAMuHMdWOxh_YvQyid-PiN7FsM=OC=0YWOzJb86pKaQn3HrjaQw@mail.gmail.com>
Subject: Re: [PATCH v2] arch: m68k: math-emu: unsigned issue, 'unsigned long'
 will never be less than zero
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 10:21 AM, Chen Gang <gang.chen@asianux.com> wrote:
> 'oldmant.m32[1]' is 'unsigned long' which never '< 0', and the original
> author wanted to check the highest bit whether set.
>
> So need make the bit test explicit (which is better than type cast form
> 'unsigned long' to 'long').
>
> The related warning: (with EXTRA_CFLAGS=-W ARCH=m68k for allmodconfig)
>   arch/m68k/math-emu/fp_arith.c:522:4: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Thanks, applied and queued for 3.11!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
