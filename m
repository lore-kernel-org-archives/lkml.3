Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3AVW0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 17:26:19 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:40614 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3AVW0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 17:26:17 -0500
MIME-Version: 1.0
In-Reply-To: <1358833677-15611-1-git-send-email-stepanm@codeaurora.org>
References: <1358833677-15611-1-git-send-email-stepanm@codeaurora.org>
Date: Tue, 22 Jan 2013 23:26:16 +0100
X-Google-Sender-Auth: SBafmQayxgLAszpeGwsBmdUvXi0
Message-ID: <CAMuHMdWedqgvrSCfpmDFdM=ww-6+8v39sz+92CQaYHO4x5jNNQ@mail.gmail.com>
Subject: Re: [PATCH] lib: vsprintf: Add %pa format specifier for phys_addr_t types
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Rob Landley <rob@landley.net>, Andrew Morton <akpm@linux-foundation.org>,
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

On Tue, Jan 22, 2013 at 6:47 AM, Stepan Moskovchenko
<stepanm@codeaurora.org> wrote:
> Add the %pa format specifier for printing a phys_addr_t
> type, since the physical address size on some platforms
> can vary based on build options, regardless of the native
> integer type.

I'm not so sure it's a good idea to start using %p for integer types.
For structures like MAC addresses, it makes life easier.

%p offers very minimal support from the compiler for checking the argument type.
At least with casting to "unsigned long long" and using %llu not much can go
wrong if there are no compiler warnings.

Also variables holding MAC address typically don't change, while there's been
lots of churn in variables changing type from unsigned long to phys_addr_t or
unsigned long long or void *. Without help of the compiler to catch
incorrect format
specifiers, it will become much more difficult to get and keep all of
them correct.

Just my two (euro)cents...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
