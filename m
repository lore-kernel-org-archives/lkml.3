Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3KEGjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 01:39:46 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:38493 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3KEGjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 01:39:44 -0500
MIME-Version: 1.0
In-Reply-To: <3478818.ZVgDgJjmfN@mistral>
References: <3478818.ZVgDgJjmfN@mistral>
Date: Tue, 5 Nov 2013 14:39:43 +0800
Message-ID: <CAA+hA=R=hZfr6Kx_5X8PQ1ck+1wD3C6LOiXyKNMN7yrqdA0YqA@mail.gmail.com>
Subject: Re: Avoid needless loop in sdhci_irq() for Card Interrupt
From: Dong Aisheng <dongas86@gmail.com>
To: Alexey Neyman <stilor@att.net>
Cc: Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Tue, Nov 5, 2013 at 2:43 AM, Alexey Neyman <stilor@att.net> wrote:
> [Patch ping #3: anyone interested in making sdhci_irq a bit faster?]
>
> Hi all,
>
> I've discovered that the sdhci_irq() function needlessly iterates re-reading
> the interrupt status and doing nothing (until it runs out of max_loops) when
> it handles the "Card Interrupt" status in the interrupt status register.
>
> The reason is that the "Card Interrupt" bit is not cleared until the
> sdhci_irq() calls mmc_signal_sdio_irq(), so if Card Interrupt was asserted,
> re-reading the interrupt status will find this bit set over and over, even if
> no other bits are reported.
>
> The fix: ignore Card Interrupt bits in the interrupt status if we already know
> that mmc_signal_sdio_irq() is going to be called at the end of sdhci_irq().
>
> Signed-off-by: Alexey Neyman <stilor@att.net>

I also noticed this issue.
Your fix looks correct to me.
But as following community working way, you need send out patches formerly,
not attach a diff file.
You can refer to 'git send-email' or try with gmail.

BTW, please enrich your patch commit message.

Regards
Dong Aisheng
