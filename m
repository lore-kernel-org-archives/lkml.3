Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3FQTB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:01:56 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:61228 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab3FQTBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:01:55 -0400
MIME-Version: 1.0
In-Reply-To: <1371483967-22527-1-git-send-email-ddaney.cavm@gmail.com>
References: <1371413189-2568-3-git-send-email-ddaney.cavm@gmail.com>
	<1371483967-22527-1-git-send-email-ddaney.cavm@gmail.com>
Date: Mon, 17 Jun 2013 21:01:54 +0200
X-Google-Sender-Auth: OxHr3Ci3byRJ6Ut8Clem3KnqyiI
Message-ID: <CAMuHMdVDex1AOe+w_tdpweRFBHzi1_ChGLgOct33SZU6f4znzw@mail.gmail.com>
Subject: Re: [PATCH v2] mn10300: Fix include dependency in irqflags.h et al.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, David Daney <david.s.daney@gmail.com>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 5:46 PM,  <ddaney.cavm@gmail.com> wrote:
> We need to pick up the definition of raw_smp_processor_id() from
> asm/smp.h.  For the !SMP case, we need to supply a definition of
> raw_smp_processor_id().
>
> Because of the include dependencies we cannot use smp_call_func_t in
> asm/smp.h, but we do need linux/thread_info.h
>
> Signed-off-by: David Daney <david.daney@cavium.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> Changes from v1: Remove redundant #ifndef __ASSEMBLY__, fix SMP case.

Many thanks, now both mn10300 defconfigs build fine.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
