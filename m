Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3H1Gta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:49:30 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:37428 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab3H1Gt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:49:28 -0400
MIME-Version: 1.0
In-Reply-To: <1376243970-6489-4-git-send-email-tomasz.figa@gmail.com>
References: <1376243970-6489-1-git-send-email-tomasz.figa@gmail.com>
	<1376243970-6489-4-git-send-email-tomasz.figa@gmail.com>
Date: Wed, 28 Aug 2013 08:49:28 +0200
Message-ID: <CACRpkdYYWZppS8pPZKejxe-RCOTkA786+k76gmsrn8jX+6ZP_w@mail.gmail.com>
Subject: Re: [PATCH 03/18] dmaengine: PL08x: Rework LLI handling to be less fragile
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-spi@vger.kernel.org, Dan Williams <djbw@fb.com>,
        Jaroslav Kysela <perex@perex.cz>, Kukjin Kim <kgene.kim@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sangbeom Kim <sbkim73@samsung.com>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 7:59 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:

> Currently memory allocated for LLIs is casted to an array of structs,
> which is fragile and also limits the driver to a single, predefined LLI
> layout, while there are some variants of PL08x, which have more fields
> in LLI (namely PL080S with its extra CCTL2).
>
> This patch makes LLIs a sequence of 32-bit words, which is just filled
> with appropriate values in appropriate order and padded with required
> amount of dummy words (currently zero, but PL080S will make better use
> of this).
>
> Suggested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>

Yes exactly like this :-)

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
