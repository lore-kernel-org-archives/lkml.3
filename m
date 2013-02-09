Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760714Ab3BIOiE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:38:04 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62814 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676Ab3BIOiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:38:02 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuK39k322MeQuzLDibGDSdidrhzqwstSWOPWwCy41Ehg-Q@mail.gmail.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
 <1359822572-26009-10-git-send-email-acourbot@nvidia.com> <20130209095803.61C653E2CF2@localhost>
 <CAAVeFuK39k322MeQuzLDibGDSdidrhzqwstSWOPWwCy41Ehg-Q@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 9 Feb 2013 14:37:39 +0000
X-Google-Sender-Auth: Dk2VN8mmml-BJCP47MBXZjZ5lxg
Message-ID: <CACxGe6uLsznC=X7TUnJajqh3GZYE7EQwo2DwTQbWPGvKFLwtSQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] gpiolib: use gpio_chips list in gpio_to_desc
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 2:21 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> On Sat, Feb 9, 2013 at 6:58 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> I'm actually going to NAK this one. This is a hot path. Having a O(1)
>> lookup from gpio number to gpio desc is important. I know you want to be
>> rid of the gpio_desc table entirely, but in this case I think it is
>> warranted. However, you can change the gpio_desc table to be a table of
>> pointers to gpio_descs instead of a table of gpio_descs. That would save
>> a lot of memory since unused GPIOs wouldn't have gpio_descs associated
>> with them. It is also the mechanism used by the IRQ subsystem.
>
> That would work - what I don't like is that it still ends being a
> fixed-size static array that is not necessarily tailored to the
> platform's needs. But I understand you don't want to punish the users
> of the integer-based API, even though the penalty should really be
> neglectable here.
>
> Well, maybe I can try to come again with this once everybody uses GPIO
> descriptors instead of integers. ;)

Yes, when everyone uses descriptor handles the problem goes away.
Until then we can just make the table fairly large. If it is pointers
to descs instead of the descs themselves then the memory cost really
isn't that significant.

We could also make the table itself grow dynamically, but I don't
think there is evidence suggesting that is needed. Thomas tried to do
the same thing with the irq desc table and found the resulting code
was far more convoluted than he wanted to support.

g.
