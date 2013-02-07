Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3BGGjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:39:31 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:39669 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab3BGGj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:39:29 -0500
MIME-Version: 1.0
In-Reply-To: <1360211979.12062.20@driftwood>
References: <1358900093-16412-1-git-send-email-stepanm@codeaurora.org>
	<1360211979.12062.20@driftwood>
Date: Thu, 7 Feb 2013 07:39:28 +0100
X-Google-Sender-Auth: Nd3iOc2jq1Ppi4YtP6mmmC8UKm0
Message-ID: <CAMuHMdWU43OPMaHdG0O6Dg6Li_ca=H1G7NKeMR8JSeWmH0Qq0g@mail.gmail.com>
Subject: Re: [PATCH v2] lib: vsprintf: Add %pa format specifier for
 phys_addr_t types
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>, mingo@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Thu, Feb 7, 2013 at 5:39 AM, Rob Landley <rob@landley.net> wrote:
> On 01/22/2013 06:14:53 PM, Stepan Moskovchenko wrote:
>> Add the %pa format specifier for printing a phys_addr_t
>> type and its derivative types (such as resource_size_t),
>> since the physical address size on some platforms can vary
>> based on build options, regardless of the native integer
>> type.
>>
>> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
>
>
> Ok, I know I'm late to the party, but doesn't LP64 apply here? Are we really
> capable of building on a target where "long" and "pointer" are different
> sizes? Last I checked the kernel was full of that assumption because there
> was an actual standard and we demanded that the compiler building us comply
> with it, just like MacOS X and the BSDs do:
>
> Standard:
> http://www.unix.org/whitepapers/64bit.html
>
> Rationale:
> http://www.unix.org/version2/whatsnew/lp64_wp.html
>
> Insane legacy reasons Windows decided to be "special":
> http://blogs.msdn.com/oldnewthing/archive/2005/01/31/363790.aspx
>
> Thus "unsigned long" should by definition be big enough. Using unsigned long
> long means you're doing 64 bit math on 32 bit targets for no apparent
> reason.
>
> What did I miss?

This is about phys_addr_t and resource_size_t, which are _physical_ addresses,
not virtual adresses. Virtual addresses are still 32-bit, so unsigned
long is fine for them.

But these days several CPUs have 36-bit physical addresses, which don't fit in
unsigned long.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
