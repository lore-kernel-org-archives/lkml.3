Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaHRHAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 03:00:04 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:61683 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaHRHAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 03:00:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAMo8Bf++rGnUkeOy3_gCimv9moStOx+fOtGAAeCXT8Hz2RsvBg@mail.gmail.com>
References: <1408335898-3109-1-git-send-email-bobby.prani@gmail.com>
	<CAMo8Bf++rGnUkeOy3_gCimv9moStOx+fOtGAAeCXT8Hz2RsvBg@mail.gmail.com>
Date: Mon, 18 Aug 2014 08:59:59 +0200
X-Google-Sender-Auth: aBzv7ysRiGXS-XNxe866weBMR6w
Message-ID: <CAMuHMdWSO6V5Ln=Yp5yEQ0YHyH38yU5uyQytxJbmazZuL-=1DQ@mail.gmail.com>
Subject: Re: [PATCH] flush_icache_range: Export symbol to fix build errors
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>, Vineet Gupta <vgupta@synopsys.com>,
        Steven Miao <realmz6@gmail.com>, David Howells <dhowells@redhat.com>,
        Richard Kuo <rkuo@codeaurora.org>,
        James Hogan <james.hogan@imgtec.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Chris Zankel <chris@zankel.net>,
        Noam Camus <noamc@ezchip.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tony Lu <zlu@tilera.com>, Kirill Tkhai <tkhai@yandex.ru>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:BLACKFIN ARCHITEC..." 
	<adi-buildroot-devel@lists.sourceforge.net>,
        "open list:QUALCOMM HEXAGON..." <linux-hexagon@vger.kernel.org>,
        "open list:METAG ARCHITECTURE" <linux-metag@vger.kernel.org>,
        "open list:SUPERH" <linux-sh@vger.kernel.org>,
        "open list:TENSILICA XTENSA..." <linux-xtensa@linux-xtensa.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 8:35 AM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> On Mon, Aug 18, 2014 at 8:24 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>> Fix building errors occuring due to a missing export of flush_icache_range() in
>> architectures missing the export.
>
> Can you be a little more specific here, what build errors?

kisskb.ellerman.id.au/kisskb/buildresult/11677809/

ERROR: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!

> [...]
>
>> diff --git a/arch/frv/include/asm/cacheflush.h b/arch/frv/include/asm/cacheflush.h
>> index edbac54..07ee4b3 100644
>> --- a/arch/frv/include/asm/cacheflush.h
>> +++ b/arch/frv/include/asm/cacheflush.h
>> @@ -72,6 +72,7 @@ static inline void flush_icache_range(unsigned long start, unsigned long end)
>>  {
>>         frv_cache_wback_inv(start, end);
>>  }
>> +EXPORT_SYMBOL(flush_icache_range);
>
> EXPORT_SYMBOL should not be placed into header file as it defines
> a non-static variable.

Indeed.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
