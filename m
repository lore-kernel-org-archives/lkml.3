Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab3BERVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:21:10 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35310 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3BERVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:21:08 -0500
MIME-Version: 1.0
In-Reply-To: <1359822572-26009-7-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
	<1359822572-26009-7-git-send-email-acourbot@nvidia.com>
Date: Tue, 5 Feb 2013 18:21:06 +0100
Message-ID: <CACRpkdYT4p8uez8DHTSsjKFb=KmWbtCXJQtyXLAJkCC7fKaErw@mail.gmail.com>
Subject: Re: [PATCH 5/9] gpiolib: use gpio_chips list in gpiochip_find_base
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 5:29 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Re-implement gpiochip_find_base using the list of chips instead of the
> global gpio_desc[] array. This makes it both simpler and more efficient,
> and is needed to remove the global descriptors array.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

So Haojian just submitted a different patch to the same piece of
code staring to search for GPIO number in ascending order instead,
but I NACKed it.

This looks like it is preserving this userspace-sensitive semantic
so that dynamically added chips will still get the same assigned
numbers.

But I want some guarantees, so state clearly in the commit
that any dynamically assigned chip will get the same base
address after this change as it got before it, and please take
this opportunity to add a comment stating that this search
method is vital for userspace ABIs, and must be preserved.

Yours,
Linus Walleij
