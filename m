Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3DYJUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 05:20:20 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:48543 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3DYJUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 05:20:18 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-2-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-2-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 11:20:18 +0200
Message-ID: <CACRpkdaMS8RBi7aWyBRRZbf7OpK82C3-79tEaq+A-QU5zbVyxQ@mail.gmail.com>
Subject: Re: [PATCH 01/32] dmaengine: ste_dma40: Assign memcpy channels in the driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin@rab.in>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>, Vinod Koul <vinod.koul@intel.com>,
        Per Forlin <per.forlin@stericsson.com>, Dan Williams <djbw@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The channels reserved for memcpy are the same for all currently
> supported platforms. With this in mind, we can ease the platform
> data passing requirement by moving these assignments out from
> platform code and place them directly into the driver.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

(...)
> -       if (num_log_chans + plat_data->memcpy_len) {
> +       if (num_log_chans + ARRAY_SIZE(dma40_memcpy_channels)) {
>                 /*
>                  * The max number of logical channels are event lines for all
>                  * src devices and dst devices

So as mentioned in review of another patch there is a kzalloc
right below here where you forget to add + ARRAY_SIZE(dma40_memcpy_channels)
please fix this...

Yours,
Linus Walleij
