Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab3BESBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:01:41 -0500
Received: from mail-ia0-f180.google.com ([209.85.210.180]:61369 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab3BESBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:01:34 -0500
MIME-Version: 1.0
In-Reply-To: <1359822572-26009-10-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
	<1359822572-26009-10-git-send-email-acourbot@nvidia.com>
Date: Tue, 5 Feb 2013 19:01:34 +0100
Message-ID: <CACRpkdbXvf8mRgpr2MrmcJcT1gTg4mfBOnF8s3=+jS5iAcMtkQ@mail.gmail.com>
Subject: Re: [PATCH 8/9] gpiolib: use gpio_chips list in gpio_to_desc
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Parse the list of chips to find the descriptor corresponding to a GPIO
> number instead of directly picking the entry of the global gpio_desc[]
> array, which is due to be removed.
>
> This turns the complexity of converting a GPIO number into a descriptor
> from O(1) to O(n) where n is the number of GPIO chips in the system.
> Since n is ought to be small anyway, there should be no noticeable
> performance impact. Moreover, GPIO users who care for speed already have
> implemented their own gpio_get_value() and gpio_set_value() with a
> fast path for the GPIO numbers that matter and this change does not
> affect such use cases.
>
> The descriptor-based GPIO API, due to be introduced soon, will make this
> lookup unnecessary.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

OK it's a nice stepping stone.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
