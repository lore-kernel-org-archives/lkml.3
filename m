Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696Ab3BIOWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:22:19 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48159 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab3BIOWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:22:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130209095803.61C653E2CF2@localhost>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
 <1359822572-26009-10-git-send-email-acourbot@nvidia.com> <20130209095803.61C653E2CF2@localhost>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Sat, 9 Feb 2013 23:21:56 +0900
X-Google-Sender-Auth: ArZ5GEupFra4P7vH197VKT_2BAg
Message-ID: <CAAVeFuK39k322MeQuzLDibGDSdidrhzqwstSWOPWwCy41Ehg-Q@mail.gmail.com>
Subject: Re: [PATCH 8/9] gpiolib: use gpio_chips list in gpio_to_desc
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 9, 2013 at 6:58 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> I'm actually going to NAK this one. This is a hot path. Having a O(1)
> lookup from gpio number to gpio desc is important. I know you want to be
> rid of the gpio_desc table entirely, but in this case I think it is
> warranted. However, you can change the gpio_desc table to be a table of
> pointers to gpio_descs instead of a table of gpio_descs. That would save
> a lot of memory since unused GPIOs wouldn't have gpio_descs associated
> with them. It is also the mechanism used by the IRQ subsystem.

That would work - what I don't like is that it still ends being a
fixed-size static array that is not necessarily tailored to the
platform's needs. But I understand you don't want to punish the users
of the integer-based API, even though the penalty should really be
neglectable here.

Well, maybe I can try to come again with this once everybody uses GPIO
descriptors instead of integers. ;)

Alex.
