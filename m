Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab3B1GsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 01:48:01 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35039 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3B1Gr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 01:47:58 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdaxMTHrabKawsufTBYVRW08YBa+hOBb12AVEzXHyox7_Q@mail.gmail.com>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
 <CAAVeFuLP0KLVL-0SS+nGWSoK1RMPCmKgZV-OjMJo-h7E1UVuXw@mail.gmail.com>
 <20130226175311.D17173E2EF8@localhost> <CAAVeFuLazaZEbbUVtR_Zyub3hgTesW6JcD9Kxgk7dUXuESpLOw@mail.gmail.com>
 <CACxGe6tyDrOF1eNNjY0j4tctx=C+m+9xkjGUFRW33hU+k6+o-g@mail.gmail.com> <CACRpkdaxMTHrabKawsufTBYVRW08YBa+hOBb12AVEzXHyox7_Q@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 28 Feb 2013 06:47:38 +0000
X-Google-Sender-Auth: 9HknMJg85Pvs1j-9GWJ8cZ970-w
Message-ID: <CACxGe6tow+iVaowMwtvQfqc7duyWzM9+39tFotn_0M=npFyakg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] gpiolib: some fixup patches
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, Ryan Mallon <rmallon@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "acourbot@nvidia.com" <acourbot@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 6:21 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Feb 27, 2013 at 8:52 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>
>> I've been playing with an idea of pulling in some basic MMIO gpio
>> access directly into gpiolib so that when appropriate gpiolib itself
>> can have a fast path for doing the register access and shadow register
>> management.
>
> Shadow registers: isn't that what regmap usually does? Or
> what are you referring to here?

Yes, regmap does shadow registers, but that is another layer of
indirection that would nullify the advantage of a fast path.

> But fastpath MMIO in the gpiolib is an appealing thought,
> given that this was a design impetus in the early history of
> the subsystem.

Indeed. I've worked on many a platform that struggled to bitbang fast
enough. A lot of the time it came down to too much indirection and
mucking about when it came to actually manipulating the GPIO. I would
like do some experiments in ways to implement a fast path and see what
the code generation looks like. Any indirection is expensive so the
trick is to minimize the number of dereferences and callbacks
involved. Unfortunately there are several common access modes that I
think should be supported, the most important being single data
register vs. set/clr and direction registers with different
polarities. Also, should the fast path only do 8-bit accesses, or can
16, 32 and 64 bit banks be supported?

g.
