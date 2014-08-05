Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbaHEIQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:16:43 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:35308 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089AbaHEIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:16:39 -0400
MIME-Version: 1.0
In-Reply-To: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
Date: Tue, 5 Aug 2014 10:16:37 +0200
X-Google-Sender-Auth: N0gmqFXBm2TgyfgsMlXjGR2GJNQ
Message-ID: <CAMuHMdXEH9koVnSS3EWjyUiiSOOOU3EdcT9JHAWNpfmVWQ2opQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the dma
 controller API
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        dmaengine@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Wed, Jul 30, 2014 at 6:03 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> The dmaengine is neither trivial nor properly documented at the moment, which
> means a lot of trial and error development, which is not that good for such a
> central piece of the system.
>
> Attempt at making such a documentation.

Great, thanks!

> +Our dma_device structure has a field called caps_mask that holds the
> +various type of transaction supported, and you need to modify this

types of transactions

> +mask using the dma_cap_set function, with various flags depending on
> +transaction types you support as an argument.

> +  * DMA_SLAVE
> +    - The device can handle device to memory transfers, including
> +      scatter-gather transfers.
> +    - While in the mem2mem case we were having two distinct type to

types

> +      deal with a single chunk to copy or a collection of them, here,
> +      we just have a single transaction type that is supposed to
> +      handle both.

> +  * DMA_INTERLEAVE
> +    - The device support interleaved transfer. Those transfers usually

supports

> +      involve an interleaved set of data, with chunks a few bytes
> +      wide, where a scatter-gather transfer would be quite
> +      inefficient.

> +The functions that we have to fill in there, and hence have to
> +implement, obviously depend on the transaction type you reported as

types

> +supported.

> +   * device_issue_pending
> +     - Takes the first descriptor in the pending queue, and start the

starts

> +       transfer. Whenever that transfer is done, it should move to the
> +       next transaction in the list.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
