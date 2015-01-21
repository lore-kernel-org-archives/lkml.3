Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbbAUJh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:37:28 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:43393 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbbAUJhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:37:22 -0500
MIME-Version: 1.0
In-Reply-To: <20150121092956.4CF89A8@black.fi.intel.com>
References: <20150121023003.GF30598@verge.net.au>
	<20150121092956.4CF89A8@black.fi.intel.com>
Date: Wed, 21 Jan 2015 10:37:20 +0100
X-Google-Sender-Auth: Chv9aTtvfd56kMUB3tUhnn62grQ
Message-ID: <CAMuHMdWyXaxobndjYDwYwqE=XJCBH_7C9TFBZYr7UpYk-rUa4A@mail.gmail.com>
Subject: Re: Possible regression in next-20150120 due to "mm: account pmd page
 tables to the process"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Simon Horman <horms@verge.net.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Linux MM <linux-mm@kvack.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill, Simon,

On Wed, Jan 21, 2015 at 10:29 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Simon Horman wrote:
>> Hi,
>>
>> I have observed what appears to be a regression caused
>> by b316feb3c37ff19cd ("mm: account pmd page tables to the process").
>>
>> The problem that I am seeing is that when booting the kzm9g board, which is
>> based on the Renesas r8a73a4 ARM SoC, using its defconfig the following the

Renesas sh73a0 ARM SoC, FWIW...

>> tail boot log below is output repeatedly and the boot does not appear to
>> proceed any further.
>>
>> I have observed this problem using next-20150120 and observed
>> that it does not occur when the patch mentioned above is reverted.
>>
>> I have also observed what appears to be the same problem when
>> booting the following boards using their defconfigs. And perhaps
>> more to the point the problem appears to affect booting all
>> boards based on Renesas ARM SoCs for which there is working support
>> to boot them by initialising them using C (as opposed to device tree).
>>
>> * armadillo800eva, based on the r8a7740 SoC
>> * mackerel, based on the sh7372
>
> This should be fixed by this:
>
> http://marc.info/?l=linux-next&m=142176280218627&w=2
>
> Please, test.

Thanks!

Confirmed the issue, and confirmed the fix (on sh73a0/kzm9g-legacy).

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
