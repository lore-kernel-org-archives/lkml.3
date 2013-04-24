Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab3DXTYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 15:24:48 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:53414 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab3DXTYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 15:24:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130424151145.GH9652@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-4-git-send-email-lee.jones@linaro.org> <20130424151145.GH9652@gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Wed, 24 Apr 2013 21:24:05 +0200
X-Google-Sender-Auth: 03xLfP03CFcEVecmjP1_izhIz1E
Message-ID: <CAH+eYFBKnEWkcJ+9DxVqnxbPS4QYtswi7Ux0JHnTWYfRFy_5Aw@mail.gmail.com>
Subject: Re: [PATCH 03/32 v3] dmaengine: ste_dma40: Use the BIT macro to
 replace ugly '(1 << x)'s
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/24 Lee Jones <lee.jones@linaro.org>:
> The aim is to make the code that little more readable.
>
> Acked-by: Vinod Koul <vnod.koul@intel.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Please pay closer attention to the semantics of each usage instead of
just replacing all x left shifts of 1 by BIT(x) for "readability".

>         if (seg_max > STEDMA40_MAX_SEG_SIZE)
> -               seg_max -= (1 << max_w);
> +               seg_max -= BIT(max_w);
>
> -       if (!IS_ALIGNED(size, 1 << max_w))
> +       if (!IS_ALIGNED(size, BIT(max_w)))
>                 return -EINVAL;

Here and in all other places where the values are from cfg->data_width,
the semantic purpose of the shift is not for setting a particular bit
but instead for converting the data_width field into the data width
value in bytes.  You should not change these usages to BIT().

It would be instead better to just make the cfg->data_width as the
number of bytes and convert them to the appropriate hardware field
values when the descriptors are constructed.  That of course should be
in another patch.
