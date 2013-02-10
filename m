Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab3BJX4h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 18:56:37 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:65367 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab3BJX4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 18:56:36 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 2/6] of: Return -ENXIO from of_parse_phandle_with_args for too large index and return errors from of_gpio_named_count
To: Andreas Larsson <andreas@gaisler.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <1359471223-4794-3-git-send-email-andreas@gaisler.com>
References: <1359471223-4794-1-git-send-email-andreas@gaisler.com> <1359471223-4794-3-git-send-email-andreas@gaisler.com>
Date: Sun, 10 Feb 2013 23:56:31 +0000
Message-Id: <20130210235631.DD54D3E0C13@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2013 15:53:39 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> This lets of_gpio_named_count return an errno on errors by being able to
> distinguish between reaching the end of the phandle list and getting some other
> error from of_parse_phandle_with_args.
> 
> Return error from of_spi_register_master when there is an "cs-gpios" list for
> which gp_gpio_named_count fails.
> 
> Adjust various drivers cope with error return from of_gpio_named_count,
> including via of_gpio_count.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Actually, I'd been meaning to fix of_gpio_count for quite a while now.
The current code uses a stupid algorithm to parse each specifier one at
a time and count how many iterations it takes before getting an error.
BLECH! A pox on me for being so lazy when I wrote it.

Anyway, your patch here spurred me on to fix it. I've just done so and
will post the patch in a few minutes. Please test and let me know if it
works for you.

g.

