Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaDXHS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:18:29 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37677 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaDXHS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:18:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140422143036.GD15745@arch.cereza>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-6-git-send-email-lftan@altera.com>
	<20140422143036.GD15745@arch.cereza>
Date: Thu, 24 Apr 2014 09:18:25 +0200
X-Google-Sender-Auth: 4p9oP3X-JlQK7H9zG2-UGXS2wBg
Message-ID: <CAMuHMdXMbGS6xFyW80Cv1xOSF=e76G16vVrboQUkgC7Q_mgZtw@mail.gmail.com>
Subject: Re: [PATCH 08/28] nios2: MMU Fault handling
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Ley Foon Tan <lftan@altera.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>, cltang@codesourcery.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 4:30 PM, Ezequiel Garcia
<ezequiel.garcia@free-electrons.com> wrote:
> On Apr 18, Ley Foon Tan wrote:
>> +
>> +bad_area_nosemaphore:
>> +     /* User mode accesses just cause a SIGSEGV */
>> +     if (user_mode(regs)) {
>
> I found that it's useful to add some printing here, just as ARM
> does. I carry this patch on my kernel:
>
> +               printk(KERN_INFO "%s: unhandled page fault (%d) at 0x%08lx, cause %ld\n",
> +                      current->comm, SIGSEGV, address, cause);
> +               show_regs(regs);
>
> Do you think we could do something like it? Maybe with a compile time option?

Can this easily be triggered from userspace? If yes, please use
pr_info_ratelimited().

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
