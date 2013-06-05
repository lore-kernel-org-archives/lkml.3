Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3FENlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:41:46 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41101 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab3FENlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:41:44 -0400
MIME-Version: 1.0
In-Reply-To: <1370262387.2025.25.camel@joe-AO722>
References: <CACRpkdZbCytqaWTK7HvfU2aMpPQVZWX2uf-NXL-rUPGJ6DQ-mQ@mail.gmail.com>
	<1369992439-5421-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<51ABF879.1090509@gmail.com>
	<1370225170.2096.12.camel@joe-AO722>
	<1370247379.29283.240.camel@smile>
	<1370262387.2025.25.camel@joe-AO722>
Date: Wed, 5 Jun 2013 16:41:44 +0300
Message-ID: <CAHp75VcLADxV9pTf=r-scKWYUCsq5LcjdvYoqMoRBp5HXj6Tyg@mail.gmail.com>
Subject: Re: [PATCH v1.1] gpiolib: append SFI helpers for GPIO API
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ryan Mallon <rmallon@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Cohen <david.a.cohen@intel.com>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 3, 2013 at 3:26 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2013-06-03 at 11:16 +0300, Andy Shevchenko wrote:
>> On Sun, 2013-06-02 at 19:06 -0700, Joe Perches wrote:
>> > On Mon, 2013-06-03 at 11:59 +1000, Ryan Mallon wrote:
>> > > On 31/05/13 19:27, Andy Shevchenko wrote:
>> > > > +       sfi_gpio_table = kmalloc(num * sizeof(*pentry), GFP_KERNEL);
>> > > Use kcalloc when you have a size and a count.
>> > kmalloc_array unless you want zero'ed memory
>> One proposed to use kmemdup to clean up a bit. What do you think?
>
> Seems correct to use kmemdup but what validates num?

num comes from SFI firmware. We only could rely on what kmalloc/kmemdup returns.

> It seems like a possible error path exists there regardless
> of whether kmemdup is used or not.

That's true. The advantage of kmemdup is an implicit memcpy. Thus, we
could drop away that line.

--
With Best Regards,
Andy Shevchenko
