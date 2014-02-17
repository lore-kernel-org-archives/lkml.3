Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaBQSCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:02:12 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:61103 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaBQSCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:02:10 -0500
MIME-Version: 1.0
In-Reply-To: <1392657637-5297-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1392657637-5297-1-git-send-email-maxime.ripard@free-electrons.com>
Date: Mon, 17 Feb 2014 19:02:09 +0100
X-Google-Sender-Auth: TxIB2Tm5jwPoJ2gZ3cgfj-L4aeI
Message-ID: <CAMuHMdXc5zyd1aBigrisvx43VVjStCMgtCcHmefdK-n5shTTmA@mail.gmail.com>
Subject: Re: [PATCH] spi: core: Fix Oops in spi_pump_messages error path
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 6:20 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> When the generic implementation of the transfer_one_message callback was called
> by the spi_pump_messages function, if that transfer was to fail, the
> spi_finalize_current_message was called twice, once in
> spi_transfer_one_message, and one in spi_pump_messages.
>
> This was causing a null pointer dereference in the second call, because the
> first one set the ->cur_msg field to NULL.
>
> Since the SPI framework expect the transfer_one_message callback to call
> spi_finalize_current_message, we can remove it from spi_pump_messages, together
> with any dereference of the ->cur_msg pointer.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: stable@vger.kernel.org

Already fixed in v3.14-rc3 in 1f802f8249a0da536877842c43c7204064c4de8b
("spi: Fix crash with double message finalisation on error handling").

There's no need to inform stable, as the problem was introduced in v3.14-rc1.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
