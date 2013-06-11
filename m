Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3FKHcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:32:43 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41763 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab3FKHcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbK_nfOhZGsd5wU-hyiwh3pHS5c42eiBfxLpCjDgBKUqJg@mail.gmail.com>
References: <51B30285.6020503@asianux.com>
	<CA+8MBbK_nfOhZGsd5wU-hyiwh3pHS5c42eiBfxLpCjDgBKUqJg@mail.gmail.com>
Date: Tue, 11 Jun 2013 09:32:39 +0200
X-Google-Sender-Auth: eOQqjt4zvTvS8EUyCQ6xlO9WdNg
Message-ID: <CAMuHMdWVx79L=ErRkNMide6xNqQt1RQr0psN8nqoADeV0h768A@mail.gmail.com>
Subject: Re: [Suggestion] arch/*/include/asm/bitops.h: about __set_bit() API.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tony Luck <tony.luck@gmail.com>
Cc: Chen Gang <gang.chen@asianux.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        alpha <linux-alpha@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        linux-am33-list@redhat.com, Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 12:26 AM, Tony Luck <tony.luck@gmail.com> wrote:
> On Sat, Jun 8, 2013 at 3:08 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> using 'unsigned int *', implicitly:
>>   ./ia64/include/asm/bitops.h:63:__set_bit (int nr, volatile void *addr)
>
> There is some downside on ia64 to your suggestion.  If "addr" is properly
> aligned for an "int", but misaligned for a long ... i.e. addr%8 == 4, then I'll
> take an unaligned reference trap if I work with long* where the current code
> working with int* does not.
>
> Now perhaps all the callers do guarantee long* alignment?  But I don't know.
>
> Apart from uniformity, there doesn't see to be any upside to changing this.

The address pointers have been supposed to be "long *" for a very long time.
Probably alpha (the second official Linux platform) did it
differently, and never
standardized to "long *".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
